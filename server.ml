open Eliom_content
open Eliom_content.Html5.D
open Common
open Service

module Chat_app =
    Eliom_registration.App (
        struct
            let application_name = "chat"
    end)

(* the client server communication bus *)
let bus = Eliom_bus.create Json.t<message>

(*
 * Login page
 *)

let login_form () =
    post_form ~service:connection_service
    (fun (username) ->
        [fieldset
            [
            label ~a:[a_for username] [pcdata "Username"];
            string_input ~input_type:`Text ~name:username ();
            br ();
            string_input ~input_type:`Submit ~value:"Login" ();
            string_input ~input_type:`Reset ~value:"Cancel" ();
            ]
        ]
    ) ()

let login_page =
    Lwt.return
        (html
            (head
                (title (pcdata "Welcome to Eliom Chat")) []
            )
            (body[
                h1 [pcdata "Eliom Chat"];
                login_form ();
            ])
        )
        
(*
 * Chat page
 *)

(* the textarea for message *)
let msg_box = raw_textarea ~a:[a_cols textarea_cols] ~name:"message" ()

let btn_send = button ~button_type:`Button [pcdata "Send"]

let msg_display = div [pcdata ""]

let chat_page username =
    Lwt.return
    (html 
        (head
            (title (pcdata ("Welcome "^username))) []
        )
        (body[
            h1 [pcdata "Eliom Chat"];
            h3 [pcdata ("You are logged in as "^username)];
            msg_box;
            p [btn_send];
            msg_display
            ]
        )
    )
