import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async (req) => {
    const { email, password, user_id } = await req.json();
    const supabaseAdmin = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_SERVICE_ROLE_KEY'));
    const { data: { user } } = await supabaseAdmin.auth.admin.createUser({
        email,
        password,
        id: user_id,
        email_confirm: true
    });
    return new Response(JSON.stringify({
        user
    }));
});
