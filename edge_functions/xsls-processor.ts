import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js";

const supabase = createClient(Deno.env.get("SUPABASE_URL"), Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"));
serve(async (req) => {
    const { bucket, name } = await req.json();
    const { data: file, error } = await supabase.storage.from(bucket).download(name);
    if (error || !file) return new Response("File download failed", {
        status: 500
    });
    +console.log("HIIIII im from xsls-processor");
    return new Response("Hello xlsx", {
        status: 200
    });
});
