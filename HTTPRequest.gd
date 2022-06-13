extends HTTPRequest


var my_full_url = "https://docs.google.com/forms/d/e/1FAIpQLScK8jJE9WbzeNVWCm4pY4HNabOQ9evnTZwK0qWTtuHJpxKR6A/formResponse";
var headers = ["Content-Type: application/x-www-form-urlencoded"]

# func _ready():
#     send_data("Send this data to Google")

func send_data(feedback):
    # Transform data so it can be sent:
    var http = HTTPClient.new()
    var headers_pool = PoolStringArray(headers)
    var my_data = {"entry.852953439" : feedback}
    var my_data_ready = http.query_string_from_dict(my_data)
    # print(my_data_ready)
    #Send data!!!!
    var result = self.request(my_full_url, headers_pool, false, http.METHOD_POST, my_data_ready)
    if result == 0:
        print("Data sent!")
    else:
        print("Error sending data!")


func _on_Send_feedback_pressed():
    var message = get_parent().get_parent().get_node("TextEdit").text
    send_data(message)
