import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async (req) => {
    const { user_id } = await req.json();
    const supabaseAdmin = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_SERVICE_ROLE_KEY'));
    const { error } = await supabaseAdmin.auth.admin.deleteUser(user_id);
    if (error) {
        return new Response(JSON.stringify({
            error: error.message
        }), {
            status: 500
        });
    }
    return new Response(JSON.stringify({
        success: true
    }), {
        status: 200
    });
});
