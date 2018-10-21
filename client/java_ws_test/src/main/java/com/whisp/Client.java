import java.util.Scanner;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;

import org.phoenixframework.channels.*;
import okhttp3.Request;

public class Client {

	public static void print_msg(JsonNode msg) {
		String username = msg.get("user").get("username").textValue();
		String text = msg.get("text").textValue();
		System.out.println(String.format("%s: %s", username, text));
	}

	public static void main(String[] args) {
		if (args.length != 2) {
			System.out.println("Usage: client <url:port> <jwt>");
			return;
		}

		String url = args[0];
		String jwt = args[1];

		try {
			System.out.println("create socket");
			Socket s = new Socket(String.format("http://%s/socket/websocket?token=%s", url, jwt));
			System.out.println("socket created");
			s.connect();

			Channel channel = s.chan("rooms:1", null);
			channel.join()
				.receive("ignore", new IMessageCallback() {
						@Override
						public void onMessage(Envelope envelope) {
							System.out.println("IGNORE");
						}
					})
				.receive("ok", new IMessageCallback() {
						@Override
						public void onMessage(Envelope envelope) {
							// System.out.println("JOINED with " + envelope.toString());
							JsonNode p = envelope.getPayload();
							JsonNode msgs = p.get("response").get("messages");
							for (JsonNode msg : msgs) {
								Client.print_msg(msg);
							}
						}
					});

			channel.on("message_created", new IMessageCallback() {
					@Override
					public void onMessage(Envelope envelope) {
						// System.out.println("MESSAGE CREATED: " + envelope.toString());
						JsonNode p = envelope.getPayload();
						Client.print_msg(p);
					}
				});
			channel.on(ChannelEvent.CLOSE.getPhxEvent(), new IMessageCallback() {
					@Override
					public void onMessage(Envelope envelope) {
						System.out.println("CLOSED: " + envelope.toString());
					}
				});
			channel.on(ChannelEvent.ERROR.getPhxEvent(), new IMessageCallback() {
					@Override
					public void onMessage(Envelope envelope) {
						System.out.println("ERROR: " + envelope.toString());
					}
				});

			Scanner sc = new Scanner(System.in);
			ObjectMapper objectMapper = new ObjectMapper();
			while (true) {
				String msg = sc.nextLine();
				if (msg.isEmpty()) {
					continue;
				}
				final ObjectNode msgNode = objectMapper.createObjectNode();
				msgNode.put("text", msg);
				channel.push("new_message", msgNode);
			}

		} catch(java.io.IOException ex) {
			System.out.println(ex.toString());
		}

	}
}
