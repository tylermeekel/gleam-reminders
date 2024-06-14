import app/paths/reminders
import app/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["reminders"] -> reminders.all_reminders_path(req)
    _ -> wisp.not_found()
  }
}
