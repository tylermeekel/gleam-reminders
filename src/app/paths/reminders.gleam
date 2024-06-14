import gleam/http.{Get}
import gleam/json.{type Json}
import wisp.{type Request, type Response}

pub type Reminder {
  Reminder(id: Int, content: String)
}

fn encode_reminder(reminder: Reminder) -> Json {
  json.object([
    #("id", json.int(reminder.id)),
    #("content", json.string(reminder.content)),
  ])
}

pub fn all_reminders_path(req: Request) -> Response {
  case req.method {
    Get -> get_reminders(req)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_reminders(_req: Request) -> Response {
  // Basic data
  let reminders = [
    Reminder(1, "Get milk"),
    Reminder(2, "Get cheese"),
    Reminder(3, "Call mom"),
  ]

  json.array(reminders, encode_reminder)
  |> json.to_string_builder()
  |> wisp.json_response(200)
}
