import gleam/http.{Get, Post}
import gleam/json.{type Json}
import wisp.{type Request, type Response}
import gleam/dynamic.{type Dynamic}
import gleam/result
import gleam/int

pub type Reminder {
  Reminder(id: Int, content: String)
}

pub type ReminderPost {
    ReminderPost(content: String)
}

fn decode_reminder(json: Dynamic) -> Result(ReminderPost, dynamic.DecodeErrors) {
    let decoder =
        dynamic.decode1(
            ReminderPost,
            dynamic.field("content", dynamic.string)
        )
    decoder(json)
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
    Post -> post_reminder(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn get_reminders(_req: Request) -> Response {
  // Example data
  // TODO: Add a database
  let reminders = [
    Reminder(1, "Get milk"),
    Reminder(2, "Get cheese"),
    Reminder(3, "Call mom"),
  ]

  json.array(reminders, encode_reminder)
  |> json.to_string_builder()
  |> wisp.json_response(200)
}

fn post_reminder(req: Request) -> Response {
    use json <- wisp.require_json(req)

    let result = {
        use reminder <- result.try(decode_reminder(json))

        let id = int.random(100)

        let object = 
            json.object([
                #("id", json.int(id)),
                #("content", json.string(reminder.content)),
            ])

        Ok(json.to_string_builder(object))
    }

    case result {
        Ok(json) -> wisp.json_response(json, 200)
        Error(_) -> wisp.unprocessable_entity()
    }

}
