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
    open Client
    let init_client () =
        let btn_send_elt = To_dom.of_button %btn_send in
        let msg_box_elt = To_dom.of_textarea %msg_box in
        let msg_display_elt = To_dom.of_div %msg_display in

        let send_msg msg =
            let _ = Eliom_bus.write %bus (Js.to_string msg) in
            msg_box_elt##value <- Js.string "";
        in

        Lwt.async
        (fun () -> 
            let open Lwt_js_events in
            let _ = Lwt.pick [
                clicks btn_send_elt
                (fun _ _ -> send_msg msg_box_elt##value; Lwt.return ())
            ] in
            Lwt_stream.iter (display_msg msg_display_elt)
                (Eliom_bus.stream %bus)
        )
}}


let () =
    Chat_app.register
    ~service:main_service
    (fun () () -> 
        ignore{unit{ init_client() }};
        main_page
    )
