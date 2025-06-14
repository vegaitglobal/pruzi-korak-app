import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (_req) => {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const supabase = createClient(supabaseUrl, supabaseKey);
    const bucketName = "pruzikorak";
    const { data: folders, error: listError } = await supabase.storage.from(bucketName).list("", {
        limit: 1000,
        offset: 0
    });
    if (listError) {
        console.error("Error listing folders:", listError.message);
        return new Response("Error listing folders", {
            status: 500
        });
    }
    for (const folder of folders ?? []) {
        if (!folder.name || !folder.id || folder.id !== null) continue;
        const folderId = folder.name;
        const { data: org, error: orgError } = await supabase.from("organisations").select("id").eq("id", folderId).maybeSingle();
        if (orgError) {
            console.error(`Error checking org ${folderId}:`, orgError.message);
            continue;
        }
        if (!org) {
            console.log(`Deleting orphan folder: ${folderId}`);
            const { data: filesInFolder } = await supabase.storage.from(bucketName).list(folderId, {
                limit: 1000
            });
            if (filesInFolder) {
                const filePaths = filesInFolder.map((file) => `${folderId}/${file.name}`);
                await supabase.storage.from(bucketName).remove(filePaths);
            }
        }
    }
    return new Response("Cleanup complete", {
        status: 200
    });
});
