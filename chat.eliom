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

let () =
    Chat_app.register
    ~service:connection_service
    (fun () name ->
        ignore{unit{
            (* the code below cannot be put into client section *)
            let btn_send_elt = To_dom.of_button %btn_send in
            let msg_box_elt = To_dom.of_textarea %msg_box in
            let msg_display_elt = To_dom.of_div %msg_display in

            Firebug.console##log(Js.string "[status] connected");
            let _ = Eliom_bus.write %bus (%name, "connected") in
            
            let send_msg msg =
                let json = %name, (Js.to_string msg) in
                let _ = Eliom_bus.write %bus (json) in
                Firebug.console##log_2
                    (Js.string "[sent]", msg);
                msg_box_elt##value <- Js.string "";
            in

            let display_msg elt (sender, msg) =
                let new_msg = Dom_html.createP Dom_html.document in
                new_msg##innerHTML <- Js.string (sender^": "^msg);
                Firebug.console##log_2
                    (Js.string "[received]", Js.string msg);
                Dom.appendChild elt new_msg
            in

            Lwt.async
            (fun () ->
                let open Lwt_js_events in
                Lwt.pick [
                    clicks btn_send_elt
                    (fun _ _ -> send_msg msg_box_elt##value;
                    Lwt.return ())
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
