package biz.nostr.signer_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.util.Log;

import java.util.Map;
import java.util.HashMap;

import androidx.activity.ComponentActivity;
import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;


public class DefaultActivityResultHandler implements ActivityResultHandler, PluginRegistry.ActivityResultListener {
    private Activity activity;
    private ActivityPluginBinding binding;
    private ActivityResultLauncher<Intent> activityResultLauncher;
    private final Map<Integer, ActivityResultCallback> callbackMap = new HashMap<>();
    private int requestCodeCounter = 1000;

    @Override
    public void init(Activity activity, ActivityPluginBinding binding) {
        this.activity = activity;
        this.binding = binding;

        if (activity instanceof ComponentActivity) {
            ComponentActivity componentActivity = (ComponentActivity) activity;
            activityResultLauncher = componentActivity.registerForActivityResult(
                    new ActivityResultContracts.StartActivityForResult(),
                    this::handleActivityResult);
        } else if (activity instanceof FragmentActivity) {
            FragmentActivity fragmentActivity = (FragmentActivity) activity;
            activityResultLauncher = fragmentActivity.registerForActivityResult(
                    new ActivityResultContracts.StartActivityForResult(),
                    this::handleActivityResult);
        } else {
            binding.addActivityResultListener(this);
        }
    }

    @Override
    public void launch(Intent intent, ActivityResultCallback callback) {
        if (activityResultLauncher != null) {
            activityResultLauncher.launch(intent);
            callbackMap.put(-1, callback);
        } else {
            int requestCode = generateRequestCode();
            callbackMap.put(requestCode, callback);
            activity.startActivityForResult(intent, requestCode);
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        ActivityResultCallback callback = callbackMap.remove(requestCode);
        if (callback != null) {
            ActivityResult result = new ActivityResult(resultCode, data);
            callback.onActivityResult(result);
            return true;
        }
        return false;
    }

    private void handleActivityResult(ActivityResult result) {
        ActivityResultCallback callback = callbackMap.remove(-1);
        if (callback != null) {
            callback.onActivityResult(result);
        }
    }

    private int generateRequestCode() {
        return requestCodeCounter++;
    }

    @Override
    public void dispose() {
        if (binding != null) {
            binding.removeActivityResultListener(this);
            binding = null;
        }
        activity = null;
    }
}
