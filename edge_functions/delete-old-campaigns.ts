// delete-old-campaigns -> edge function that check if campaigns with enddate older than 5 days exist, and deletes them if they do - this function is triggered by a cron job every day


import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

Deno.serve(async (req) => {
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseAnonKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    const supabaseClient = createClient(supabaseUrl, supabaseAnonKey);
    const today = new Date();
    const fiveDaysAgo = new Date(today);
    fiveDaysAgo.setDate(today.getDate() - 5);
    const { data, error } = await supabaseClient.from('campaigns').delete().lte('end_date', fiveDaysAgo.toISOString());
    if (error) {
        console.error("Error while deleting inactive campaigns.");
        return new Response(JSON.stringify({
            error: error.message
        }), {
            headers: {
                'Content-Type': 'application/json'
            },
            status: 400
        });
    }
    console.info("Deleted inactive campaigns successfully.");
    return new Response(JSON.stringify({
        message: 'Old campaigns deleted successfully'
    }), {
        headers: {
            'Content-Type': 'application/json'
        },
        status: 200
    });
});