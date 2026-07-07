import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function run() {
  const { data: motos } = await supabase.from('motorcycles').select('id, brand, model, user_id');
  console.log("Motos (via anon key):", motos);
}
run();
