# Road to Glory

World Cup prediction campaign, ready to deploy on Vercel with Supabase storage.

## Deploy

1. Create a free Supabase project and run `supabase-schema.sql` in **SQL Editor**.
2. In Vercel, import this folder as a new project.
3. Add `SUPABASE_URL` and `SUPABASE_SECRET_KEY` in **Settings → Environment Variables** using `.env.example` as the guide.
4. Deploy. Do not put the Supabase secret key in client-side files.

## If submission says “service unavailable”

The browser form submits to `/api/submit`, which only runs on a Vercel deployment (or through `vercel dev`). Opening `index.html` directly or using a basic live-preview extension will not run the API and will cause `fetch failed`.

On Vercel, make sure both environment variables are added for the **Production** environment, then redeploy:

- `SUPABASE_URL`
- `SUPABASE_SECRET_KEY`

If you already launched an older version, run `supabase-migration-v3.sql` once instead. This creates the new clean `competition_entries` table and preserves any earlier test data in `predictions`.

Entries close on **14 July 2026, 23:59:59 India Standard Time**. Update `DEADLINE` in both `app.js` and `api/submit.js` if the campaign date changes.

## Changing teams

Edit the four team names and flag emoji in `index.html`, then update the matching `flags` values in `app.js`. The current first semi-final is Argentina vs England.

## Reading entries

Open the `competition_entries` table in Supabase and use its CSV export. Only your server key can access this data; visitors cannot read the table.
