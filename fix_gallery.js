import fs from 'fs';
import { execSync } from 'child_process';

async function fix() {
  const urls = [
    { id: '5db178b1-ae7e-46bb-831d-00f039c74a1c', url: 'https://www.instagram.com/p/DZ5gTaHA4ca' },
    { id: 'f4351e93-160c-4f69-b573-796338b67814', url: 'https://www.instagram.com/p/DZ42DYpFk8G' },
    { id: '81a04712-502a-4e1c-9122-b66c66a1fa58', url: 'https://www.instagram.com/p/DZ8YAMnlu1V' },
    { id: '5b8a7728-4aab-41de-8701-4f86ae09ddab', url: 'https://www.instagram.com/p/DaB3sDOgS2c' }
  ];

  for (let i = 0; i < urls.length; i++) {
    const { id, url } = urls[i];
    console.log("Fetching", url);
    const res = await fetch(`https://api.microlink.io/?url=${url}`);
    const data = await res.json();
    const imgUrl = data?.data?.image?.url;
    if (imgUrl) {
      console.log("Found img:", imgUrl);
      const ext = imgUrl.includes('.heic') ? 'heic' : 'jpg';
      const filename = `public/ig-${id}.${ext}`;
      execSync(`curl -s "${imgUrl}" -o ${filename}`);
      
      const updateQuery = `UPDATE public.gallery_items SET image_url = '/ig-${id}.${ext}' WHERE id = '${id}';`;
      execSync(`docker exec -i supabase_db_dphpnagvizyphgehussx psql -U postgres -d postgres -c "${updateQuery}"`);
      console.log("Updated", id);
    } else {
      console.log("No image for", url);
    }
  }
}
fix();
