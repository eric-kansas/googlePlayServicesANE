package com.tapjoy.android.gps;

import java.util.Map;
import java.util.HashMap;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class GPSContext extends FREContext {
    public GPSContext() {
        super();
    }

    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
        return functionMap;
    }

    public void dispose() {

    }
}
