package com.tapjoy.android.gps;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.tapjoy.android.gps.GPSContext;

public class GPSExtension implements FREExtension {
    public static FREContext context;

    public GPSExtension() {
    }

    public FREContext createContext(String arg0) {
        return context = new GPSContext();
    }

    public void initialize() {

    }

    public void dispose() {
        context = null;
    }
}
