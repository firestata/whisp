import org.phoenixframework.channels.*;
import okhttp3.Request;

public class Client {

	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Need to provide a JWT");
			return;
		}

		String jwt = args[0]

		try {
			System.out.println("create socket");
			Socket s = new Socket("http://johnnyfive.xyz:4000/socket/websocket?token=" + jwt);
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
							System.out.println("JOINED with " + envelope.toString());
						}
					});

			channel.on("new_message", new IMessageCallback() {
					@Override
					public void onMessage(Envelope envelope) {
						System.out.println("NEW MESSAGE: " + envelope.toString());
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

		} catch(java.io.IOException ex) {
			System.out.println(ex.toString());
		}

	}
}
