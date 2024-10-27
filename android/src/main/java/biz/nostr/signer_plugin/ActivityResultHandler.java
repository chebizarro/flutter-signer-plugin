package biz.nostr.signer_plugin;

import android.app.Activity;
import android.content.Intent;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;


public interface ActivityResultHandler {
    void init(Activity activity, ActivityPluginBinding binding);
    void launch(Intent intent, ActivityResultCallback callback);
    void dispose();

    interface ActivityResultCallback {
        void onActivityResult(ActivityResult result);
    }
}

