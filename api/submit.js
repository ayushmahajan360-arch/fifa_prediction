// Vercel Serverless Function. Never expose SUPABASE_SECRET_KEY in the browser.
const DEADLINE = new Date('2026-07-14T23:59:59+05:30');
const required = ['firstName','lastName','mobile','semiOne','semiTwo','result','champion','manOfMatch','goldenBoot'];

export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (new Date() > DEADLINE) return res.status(403).json({ error: 'Predictions are now closed.' });
  const body = req.body || {};
  if (!body.consent || required.some(key => !String(body[key] || '').trim())) return res.status(400).json({ error: 'Please complete all required fields.' });
  const mobile = String(body.mobile).replace(/[^0-9+]/g, '');
  if (mobile.replace(/\D/g, '').length < 8) return res.status(400).json({ error: 'Please enter a valid mobile number.' });
  if (!String(body.scoreOne ?? '').trim() || !String(body.scoreTwo ?? '').trim() || !Number.isInteger(Number(body.scoreOne)) || !Number.isInteger(Number(body.scoreTwo)) || Number(body.scoreOne) < 0 || Number(body.scoreTwo) < 0 || Number(body.scoreOne) > 20 || Number(body.scoreTwo) > 20) return res.status(400).json({ error: 'Please enter valid final scores.' });
  if (![body.semiOne, body.semiTwo, 'Draw'].includes(body.result)) return res.status(400).json({ error: 'Invalid final result.' });
  if ((Number(body.scoreOne) === Number(body.scoreTwo)) !== (body.result === 'Draw')) return res.status(400).json({ error: 'The selected result must match the score.' });
  if (body.result !== 'Draw' && !String(body.firstGoalscorer || '').trim()) return res.status(400).json({ error: 'Please provide the first goalscorer.' });
  if (Number(body.scoreOne) === Number(body.scoreTwo) && !body.penaltyWinner) return res.status(400).json({ error: 'A drawn final needs a penalty winner.' });
  const entry = { first_name: body.firstName.trim(), last_name: body.lastName.trim(), mobile, semi_one: body.semiOne, semi_two: body.semiTwo, score_one: Number(body.scoreOne), score_two: Number(body.scoreTwo), result: body.result, champion: body.champion, penalty_winner: body.penaltyWinner || null, first_goalscorer: String(body.firstGoalscorer || '').trim() || null, man_of_match: body.manOfMatch.trim(), golden_boot: body.goldenBoot.trim() };
  try {
    const response = await fetch(`${process.env.SUPABASE_URL}/rest/v1/predictions`, { method:'POST', headers:{ apikey:process.env.SUPABASE_SECRET_KEY, Authorization:`Bearer ${process.env.SUPABASE_SECRET_KEY}`, 'Content-Type':'application/json', Prefer:'return=representation' }, body:JSON.stringify(entry) });
    if (response.status === 409 || response.status === 23505) return res.status(409).json({ error: 'This mobile number has already submitted a prediction.' });
    const result = await response.json(); if (!response.ok) { console.error(result); throw new Error('Database error'); }
    return res.status(201).json({ id: result[0]?.id });
  } catch (error) { console.error(error); return res.status(500).json({ error: 'Unable to save your prediction. Please try again.' }); }
}
