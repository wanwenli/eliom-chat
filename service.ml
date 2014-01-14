let chat_service =
    Eliom_service.service
        ~path:["chat"]
        ~get_params:Eliom_parameter.unit
    ()

let login_service =
    Eliom_service.service
        ~path:[]
        ~get_params:Eliom_parameter.unit
    ()

let connection_service =
    Eliom_service.post_service
        ~fallback:chat_service
        ~post_params:Eliom_parameter.(string "name")
    ()
