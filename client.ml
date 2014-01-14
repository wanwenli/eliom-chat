open Eliom_content
open Eliom_content.Html5.D
open Common
open Lwt

let display_msg elt msg =
    let new_msg = Dom_html.createP Dom_html.document in
    new_msg##innerHTML <- Js.string msg;
    Dom.appendChild elt new_msg
