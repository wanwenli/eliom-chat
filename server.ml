open Eliom_content
open Eliom_content.Html5.D
open Common

module Chat_app =
    Eliom_registration.App (
        struct
            let application_name = "chat"
    end)

(* the client server communication bus *)
let bus = Eliom_bus.create Json.t<message>

(* the textarea for message *)
let msg_box = raw_textarea ~a:[a_cols textarea_cols] ~name:"message" ()

let btn_send = button ~button_type:`Button [pcdata "Send"]

let msg_display = div [pcdata ""]

let main_page =
    Lwt.return
        (html 
            (head
                (title (pcdata "Chat")) []
            )
            (body[
                h1 [pcdata "Chat"];
                msg_box;
                p [btn_send];
                msg_display
                ]
            )
        )
