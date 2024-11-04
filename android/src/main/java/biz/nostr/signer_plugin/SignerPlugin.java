package biz.nostr.signer_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.result.ActivityResult;
import androidx.annotation.NonNull;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import biz.nostr.android.nip55.Signer;
import biz.nostr.android.nip55.IntentBuilder;
import biz.nostr.android.nip55.AppInfo;

/** SignerPlugin */
public class SignerPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
	/// The MethodChannel that will the communication between Flutter and native
	/// Android
	///
	/// This local reference serves to register the plugin with the Flutter Engine
	/// and unregister it
	/// when the Flutter Engine is detached from the Activity
	private MethodChannel channel;
	private ActivityResultHandler activityResultHandler;
	private String signerPackageName = null;
	private Context context;
	private Activity activity;
	private static final String TAG = "SignerPlugin";

	@Override
	public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
		Log.d(TAG, "onAttachedToActivity called");
		this.activity = binding.getActivity();
		activityResultHandler = new DefaultActivityResultHandler();
		activityResultHandler.init(activity, binding);
	}

	@Override
	public void onDetachedFromActivity() {
		if (activityResultHandler != null) {
			activityResultHandler.dispose();
			activityResultHandler = null;
		}
		this.activity = null;
	}

	@Override
	public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
		Log.d(TAG, "onAttachedToEngine called");
		this.context = flutterPluginBinding.getApplicationContext();
		channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "signer_plugin");
		channel.setMethodCallHandler(this);
	}

	@Override
	public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
		Log.d(TAG, "onDetachedFromEngine called");
		channel.setMethodCallHandler(null);
		channel = null;
		context = null;
	}

	@Override
	public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
		switch (call.method) {
			case "isExternalSignerInstalled":
				isExternalSignerInstalled(call, result);
				break;
			case "getInstalledSignerApps":
				getInstalledSignerApps(call, result);
				break;
			case "setPackageName":
				setPackageName(call, result);
				break;
			case "getPublicKey":
				getPublicKey(call, result);
				break;
			case "signEvent":
				signEvent(call, result);
				break;
			case "nip04Encrypt":
				nip04Encrypt(call, result);
				break;
			case "nip04Decrypt":
				nip04Decrypt(call, result);
				break;
			case "nip44Encrypt":
				nip44Encrypt(call, result);
				break;
			case "nip44Decrypt":
				nip44Decrypt(call, result);
			case "decryptZapEvent":
				decryptZapEvent(call, result);
			case "getRelays":
				getRelays(call, result);
				break;
		}
	}

	private void isExternalSignerInstalled(MethodCall call, MethodChannel.Result result) {
		String packageName = call.argument("packageName");
		List<ResolveInfo> signers = Signer.isExternalSignerInstalled(context, packageName);
		result.success(!signers.isEmpty());
	}

	private void getInstalledSignerApps(MethodCall call, MethodChannel.Result result) {
		List<AppInfo> signerAppInfos = Signer.getInstalledSignerApps(context);
		List<Object> appsList = new java.util.ArrayList<>();
		for (AppInfo signerAppInfo : signerAppInfos) {
			java.util.Map<String, Object> appInfo = new java.util.HashMap<>();
			appInfo.put("name", signerAppInfo.name);
			appInfo.put("packageName", signerAppInfo.packageName);
			appInfo.put("iconData", signerAppInfo.iconData);
			appInfo.put("iconUrl", signerAppInfo.iconUrl);
			appsList.add(appInfo);
		}
		result.success(appsList);
	}

	private String getPackageName(MethodCall call) {
		String packageName = call.argument("packageName");
		if (packageName == null || packageName.isEmpty()) {
			packageName = signerPackageName;
		}
		return packageName;
	}

	private void setPackageName(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Missing or empty packageName parameter", null);
			return;
		}
		signerPackageName = packageName;
		result.success(null);
	}

	private void getPublicKey(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}
		String publicKey = Signer.getPublicKey(context, packageName);
		if (publicKey != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("npub", publicKey);
			ret.put("package", packageName);
			result.success(ret);
		} else {
			String permissions = call.argument("permissions");
			Intent intent = IntentBuilder.getPublicKeyIntent(packageName, permissions);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	private void signEvent(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}
		String eventJson = call.argument("eventJson");
		String eventId = call.argument("eventId");
		String npub = call.argument("npub");

		if (eventJson == null || eventId == null || npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}
		String[] signedEventJson = Signer.signEvent(context, packageName, eventJson, npub);
		if (signedEventJson != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("signature", signedEventJson[0]);
			ret.put("id", eventId);
			ret.put("event", signedEventJson[1]);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.signEventIntent(packageName, eventJson, eventId, npub);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	private void nip04Encrypt(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}
		String plainText = call.argument("plainText");
		String pubKey = call.argument("pubKey");
		String npub = call.argument("npub");
		String id = call.argument("id");

		if (plainText == null || pubKey == null || npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}

		String encryptedText = Signer.nip04Encrypt(context, packageName, plainText, pubKey, npub);
		if (encryptedText != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("result", encryptedText);
			ret.put("id", id);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.nip04EncryptIntent(packageName, plainText, id, npub, pubKey);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	private void nip44Encrypt(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}
		String plainText = call.argument("plainText");
		String pubKey = call.argument("pubKey");
		String npub = call.argument("npub");
		String id = call.argument("id");

		if (plainText == null || pubKey == null || npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}

		String encryptedText = Signer.nip44Encrypt(context, packageName, plainText, pubKey, npub);
		if (encryptedText != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("result", encryptedText);
			ret.put("id", id);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.nip04EncryptIntent(packageName, plainText, id, npub, pubKey);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	public void nip04Decrypt(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}
		String encryptedText = call.argument("encryptedText");
		String pubKey = call.argument("pubKey");
		String npub = call.argument("npub");
		String id = call.argument("id");

		if (encryptedText == null || pubKey == null || npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}

		String decryptedText = Signer.nip04Decrypt(context, packageName, encryptedText, pubKey, npub);
		if (decryptedText != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("result", decryptedText);
			ret.put("id", id);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.nip04DecryptIntent(packageName, encryptedText, id, pubKey, npub);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	public void nip44Decrypt(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}
		String encryptedText = call.argument("encryptedText");
		String pubKey = call.argument("pubKey");
		String npub = call.argument("npub");
		String id = call.argument("id");

		if (encryptedText == null || pubKey == null || npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}

		String decryptedText = Signer.nip44Decrypt(context, packageName, encryptedText, pubKey, npub);
		if (decryptedText != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("result", decryptedText);
			ret.put("id", id);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.nip44DecryptIntent(packageName, encryptedText, id, pubKey, npub);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	public void decryptZapEvent(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}

		String eventJson = call.argument("eventJson");
		String npub = call.argument("npub");
		String id = call.argument("id");

		if (eventJson == null || npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}

		String decryptedEventJson = Signer.decryptZapEvent(context, packageName, eventJson, npub);
		if (decryptedEventJson != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("result", decryptedEventJson);
			ret.put("id", id);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.decryptZapEventIntent(signerPackageName, eventJson, id, npub);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	public void getRelays(MethodCall call, MethodChannel.Result result) {
		String packageName = getPackageName(call);
		if (packageName == null || packageName.isEmpty()) {
			result.error("ERROR", "Signer package name not set. Call setPackageName first.", null);
			return;
		}

		String npub = call.argument("current_user");
		String id = call.argument("id");

		if (npub == null) {
			result.error("ERROR", "Missing parameters", null);
			return;
		}

		String relayJson = Signer.getRelays(context, packageName, npub);
		if (relayJson != null) {
			java.util.Map<String, Object> ret = new java.util.HashMap<>();
			ret.put("result", relayJson);
			ret.put("id", id);
			result.success(ret);
		} else {
			Intent intent = IntentBuilder.getRelaysIntent(signerPackageName, id, npub);
			activityResultHandler.launch(intent, activityResult -> {
				handleActivityResult(activityResult, result);
			});
		}
	}

	private void handleActivityResult(ActivityResult activityResult, MethodChannel.Result result) {
		Intent data = activityResult.getData();
		if (data != null) {
			Bundle extras = data.getExtras();
			Map<String, Object> resultData = new HashMap<>();
			if (extras != null) {
				for (String key : extras.keySet()) {
					Object value = extras.get(key);
					resultData.put(key, value);
				}
			}
			result.success(resultData);
		} else {
			result.error("NO_DATA", "No data returned from activity.", null);
		}
	}

	@Override
	public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
		Log.d(TAG, "onReattachedToActivityForConfigChanges called");
		onAttachedToActivity(binding);
	}

	@Override
	public void onDetachedFromActivityForConfigChanges() {
		Log.d(TAG, "onDetachedFromActivityForConfigChanges called");
		onDetachedFromActivity();
	}

}
