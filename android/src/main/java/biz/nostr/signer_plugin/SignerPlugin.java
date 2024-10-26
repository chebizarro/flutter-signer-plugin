package biz.nostr.signer_plugin;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import biz.nostr.nip55.NostrSigner;

/** SignerPlugin */
public class SignerPlugin implements FlutterPlugin, MethodCallHandler {
	/// The MethodChannel that will the communication between Flutter and native
	/// Android
	///
	/// This local reference serves to register the plugin with the Flutter Engine
	/// and unregister it
	/// when the Flutter Engine is detached from the Activity
	private MethodChannel channel;
	private NostrSigner signer;

	@Override
	public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
		channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "signer_plugin");
		channel.setMethodCallHandler(this);
		signer = new NostrSigner();
	}

	@Override
	public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
		switch (call.method) {
			case "getPlatformVersion":
				result.success("Android " + android.os.Build.VERSION.RELEASE);
				break;
			case "getPublicKey":
				getPublicKey(result);
				break;
			case "signEvent":
				String event = call.argument("event");
				signEvent(event, result);
				break;
			default:
				result.notImplemented();
				break;
		}

	}

	// Implement the getPublicKey method
	private void getPublicKey(MethodChannel.Result result) {
		// Your logic to get the public key
		String publicKey = "npub1examplepublickeyfromnative";
		result.success(publicKey);
	}

	// Implement the signEvent method
	private void signEvent(String event, MethodChannel.Result result) {
		// Your logic to sign the event
		String signedEvent = "signed_" + event;
		result.success(signedEvent);
	}

	@Override
	public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
		channel.setMethodCallHandler(null);
	}

	// Implement ActivityAware methods if needed
	@Override
	public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
		this.activity = binding.getActivity();
	}

	@Override
	public void onDetachedFromActivityForConfigChanges() {
		this.activity = null;
	}

	@Override
	public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
		this.activity = binding.getActivity();
	}

	@Override
	public void onDetachedFromActivity() {
		this.activity = null;
	}
}
