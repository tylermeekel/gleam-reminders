import wisp.{type Request, type Response}
import gleam/http.{Get}

pub type Reminder {
    Reminder(id: Int, content: String)
}

pub fn reminders_path(req: Request) -> Response {
    case req.method {
        Get -> get_reminders(req)
        _ -> wisp.method_not_allowed([Get])
    }
}

fn get_reminders(req: Request) -> Response {
    // Basic data
    let reminders = [
        Reminder(1, "Get milk"),
        Reminder(2, "Get cheese"),
        Reminder(3, "Call mom")
    ]

    
}