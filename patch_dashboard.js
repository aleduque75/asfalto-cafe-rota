import fs from 'fs';
const path = 'src/routes/_authenticated/dashboard.tsx';
let code = fs.readFileSync(path, 'utf8');

// We need to change the data loading logic to fetch motos first.
// Replace the Promise.all section
const oldCode = `      const [{ data: p }, { data: m }, { data: it }, { data: rc }, { data: rt }, { data: polls }, { data: bdays }, { data: plansData }] = await Promise.all([
        supabase.from("profiles").select("full_name, partner_id").eq("id", u.user.id).maybeSingle(),
        supabase.from("motorcycles").select("*").eq("user_id", u.user.id).order("created_at", { ascending: false }),
        supabase.from("maintenance_items").select("*"),
        supabase.from("maintenance_records").select("*").order("service_date", { ascending: false }).limit(8),
        supabase.from("routes").select("id, title, destination, start_date, waze_url, route_type").in("status", ["open", "planning"]).order("start_date", { ascending: true }).limit(1).maybeSingle(),
        (supabase as any).from("polls").select("*").eq("status", "active"),
        supabase.rpc("get_todays_birthdays"),
        supabase.from("trip_financial_plans").select(\`id, costs, profile_id, route:routes(id, title, status)\`)
      ]);`;

const newCode = `      const { data: m } = await supabase.from("motorcycles").select("*").eq("user_id", u.user.id).order("created_at", { ascending: false });
      const motoIds = (m || []).map(moto => moto.id);
      
      const [{ data: p }, { data: it }, { data: rc }, { data: rt }, { data: polls }, { data: bdays }, { data: plansData }] = await Promise.all([
        supabase.from("profiles").select("full_name, partner_id").eq("id", u.user.id).maybeSingle(),
        motoIds.length > 0 ? supabase.from("maintenance_items").select("*").in("motorcycle_id", motoIds) : Promise.resolve({ data: [] }),
        motoIds.length > 0 ? supabase.from("maintenance_records").select("*").in("motorcycle_id", motoIds).order("service_date", { ascending: false }).limit(8) : Promise.resolve({ data: [] }),
        supabase.from("routes").select("id, title, destination, start_date, waze_url, route_type").in("status", ["open", "planning"]).order("start_date", { ascending: true }).limit(1).maybeSingle(),
        (supabase as any).from("polls").select("*").eq("status", "active"),
        supabase.rpc("get_todays_birthdays"),
        supabase.from("trip_financial_plans").select(\`id, costs, profile_id, route:routes(id, title, status)\`)
      ]);`;

code = code.replace(oldCode, newCode);
fs.writeFileSync(path, code);
