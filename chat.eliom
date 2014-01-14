{shared{
    open Eliom_lib
    open Eliom_content
    open Eliom_content.Html5
    open Eliom_content.Html5.D
    open Lwt
    open Common
}}

open Server
open Service

{client{

}}

let () =
    Chat_app.register
    ~service:connection_service
    (fun () name ->
        ignore{unit{
            (* the code below cannot be put into client section *)
            let btn_send_elt = To_dom.of_button %btn_send in
            let msg_box_elt = To_dom.of_textarea %msg_box in
            let msg_display_elt = To_dom.of_div %msg_display in
            
            let send_msg msg =
                let _ = Eliom_bus.write %bus (Js.to_string msg) in
                Firebug.console##log_2
                    (Js.string "[sending]", msg);
                msg_box_elt##value <- Js.string "";
            in

            let display_msg elt msg =
                let new_msg = Dom_html.createP Dom_html.document in
                new_msg##innerHTML <- Js.string (%name^": "^msg);
                Firebug.console##log_2
                    (Js.string "[received]", Js.string msg);
                Dom.appendChild elt new_msg
            in

            Lwt.async
            (fun () ->
                let open Lwt_js_events in
                Lwt.pick [
                    clicks btn_send_elt
                    (fun _ _ -> send_msg msg_box_elt##value; Lwt.return ())
            ]);

            Lwt.async
            (fun () ->
                Lwt_stream.iter (display_msg msg_display_elt)
                    (Eliom_bus.stream %bus)
            )
        }};
        chat_page name
    );

    Chat_app.register
    ~service:chat_service
    (fun () () -> 
        chat_page "anonymous"
    );

    Chat_app.register
    ~service:login_service
    (fun () () -> login_page);
