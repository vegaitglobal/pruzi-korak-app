// create - storage - folder edge function - creates a folder in storage in the pruzikorak bucket where the name of the folder is the id of the organisation for which the folder is for

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

Deno.serve(async (req) => {
  if (req.method === 'POST') {
    const { orgId } = await req.json();
    if (!orgId) {
      return new Response(JSON.stringify({
        error: 'Organization ID is required'
      }), {
        status: 400,
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }
    const supabaseClient = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_SERVICE_ROLE_KEY'));
    const folderPath = `${orgId}/.keep`;
    const { data, error } = await supabaseClient.storage.from('pruzikorak').upload(folderPath, new Blob([
      ''
    ]), {
      contentType: 'text/plain',
      upsert: true
    });
    if (error) {
      console.error(error);
      return new Response(JSON.stringify({
        error: error.message
      }), {
        status: 500,
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      message: 'Folder created successfully',
      data
    }), {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
  return new Response(JSON.stringify({
    error: 'Method not allowed'
  }), {
    status: 405,
    headers: {
      'Content-Type': 'application/json'
    }
  });
});