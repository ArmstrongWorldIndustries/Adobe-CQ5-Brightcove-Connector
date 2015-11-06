package com.coresecure.brightcove.wrapper.utils;

import com.coresecure.brightcove.wrapper.objects.Geo;
import com.coresecure.brightcove.wrapper.objects.RelatedLink;
import com.coresecure.brightcove.wrapper.objects.Schedule;
import org.apache.sling.commons.json.JSONArray;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Map;

public class ObjectSerializer {
    public static JSONObject toJSON(Object obj, String[] fields) throws JSONException {
        JSONObject json = new JSONObject();
        for (String field : fields) {
            try {
                Class<?> c = obj.getClass();

                Field f = c.getDeclaredField(field);
                f.setAccessible(true);
                if (f.getType().equals(Collection.class)) {
                    Collection value = (Collection) f.get(obj);
                    if (value != null) {
                        JSONArray itemCollection = new JSONArray(value);
                        json.put(field, itemCollection);
                    }
                } else if (f.getType().equals(String.class)) {
                    String value = (String) f.get(obj);
                    if (value != null && !value.isEmpty()) json.put(field, value);
                } else if (f.getType().equals(Map.class)) {
                    Map value = (Map) f.get(obj);
                    if (value != null) {
                        JSONObject itemObj = new JSONObject((Map) f.get(obj));
                        json.put(field, itemObj);
                    }
                } else if (f.getType().equals(Boolean.class)) {
                    boolean value = (Boolean) f.get(obj);
                    json.put(field, value);
                } else if (f.getType().equals(RelatedLink.class)) {
                    RelatedLink value = (RelatedLink) f.get(obj);
                    if (value != null) json.put(field, value.toJSON());
                } else if (f.getType().equals(Geo.class)) {
                    Geo value = (Geo) f.get(obj);
                    if (value != null) json.put(field, value.toJSON());
                } else if (f.getType().equals(Schedule.class)) {
                    Schedule value = (Schedule) f.get(obj);
                    if (value != null) json.put(field, value.toJSON());
                }
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return json;
    }
}
