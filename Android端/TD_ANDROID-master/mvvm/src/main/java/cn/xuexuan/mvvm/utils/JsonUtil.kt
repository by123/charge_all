package cn.xuexuan.mvvm.utils

import com.elvishew.xlog.formatter.FormatException
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonObject
import com.google.gson.reflect.TypeToken
import org.json.JSONArray
import org.json.JSONObject
import java.io.FileReader
import java.lang.reflect.Type
import java.util.*

/**
 * json tools;
 *
 * @author xuexuan
 */
object JsonUtil {

    @Volatile
    private var gson: Gson? = null


    init {
        if (null == gson) {
            synchronized(JsonUtil::class.java) {
                if (null == gson) {
                    //                    gson = new Gson();
                    gson = GsonBuilder().disableHtmlEscaping().create()
                }
            }
        }

    }

    /**
     * 获取GsonObject对象
     *
     * @param o Object
     * @return JsonObject
     */
    fun beanToJsonObject(o: Any): JsonObject {
        return gson!!.toJsonTree(o).asJsonObject
    }

    /**
     * 将对象转换成json格式
     *
     * @param ts Object
     * @return String
     */
    fun objectToJson(ts: Any): String? {
        var jsonStr: String? = null
        if (gson != null) {
            jsonStr = gson!!.toJson(ts)
        }
        return jsonStr
    }

    /**
     * 将对象转换成json格式(并自定义日期格式)
     *
     * @param ts Object
     * @return String
     */
//    fun objectToJsonDateSerializer(ts: Any, dateFormat: String): String {
//        gson = GsonBuilder().registerTypeHierarchyAdapter(Date::class.java, { src, typeOfSrc, context ->
//            val format = SimpleDateFormat(dateFormat)
//            JsonPrimitive(format.format(src))
//        } as JsonSerializer<Date>).setDateFormat(dateFormat).create()
//        return gson!!.toJson(ts)
//    }

    /**
     * 将json格式转换成list对象
     *
     * @param jsonStr String
     * @return List
     */
    fun <T> jsonToList(jsonStr: String): List<T>? {
        var objList: List<T>? = null
        if (gson != null) {
            val type = object : TypeToken<List<T>>() {

            }.type
            objList = gson!!.fromJson<List<T>>(jsonStr, type)
        }
        return objList
    }

    /**
     * @param jsonStr String
     * @param type    Class
     * @return List<T>
     * @description 将Json转为对应的List
    </T> */
    fun <T> jsonToList(jsonStr: String, type: Class<T>): List<T>? {

        val listType = object : TypeToken<ArrayList<T>>() {}.type
        var list: List<T>? = null
        if (gson != null) {
            list = gson!!.fromJson<List<T>>(jsonStr, listType)
        }
        return list
    }

    /**
     * 将json格式转换成map对象
     *
     * @param jsonStr String
     * @return Map
     */
    fun <K, V> jsonToMap(jsonStr: String): Map<K, V>? {
        var objMap: Map<K, V>? = null
        if (gson != null) {
            val type = object : TypeToken<Map<K, V>>() {

            }.type
            objMap = gson!!.fromJson<Map<K, V>>(jsonStr, type)
        }
        return objMap
    }

    /**
     * 将json转换成bean对象
     *
     * @param jsonStr String
     * @return T
     */
    fun <T> jsonToBean(jsonStr: String, cl: Class<T>): T? {
        return if (gson != null) gson!!.fromJson(jsonStr, cl) else null
    }

    /**
     * 将json转换成bean对象
     *
     * @param jsonStr String
     * @param cl      Class
     * @return T
     */
//    fun <T> jsonToBeanDateSerializer(jsonStr: String, cl: Class<T>, pattern: String): T? {
//        val bean: T
//        gson = GsonBuilder().registerTypeAdapter(Date::class.java, { json, typeOfT, context ->
//            val format = SimpleDateFormat(pattern)
//            val dateStr = json.getAsString()
//            try {
//                return@new GsonBuilder().registerTypeAdapter format . parse dateStr
//            } catch (e: ParseException) {
//                e.printStackTrace()
//            }
//
//            null
//        } as JsonDeserializer<Date>).setDateFormat(pattern).create()
//        bean = gson!!.fromJson(jsonStr, cl)
//        return bean
//    }


    fun <T> fromJson(fileReader: FileReader, from: Type): T {
        return gson!!.fromJson(fileReader, from)
    }

    fun <T> fromJson(json: String, typeToken: TypeToken<T>): T {
        return gson!!.fromJson(json, typeToken.type)
    }

    fun <T> fromJson(json: String, from: Type): T {
        return gson!!.fromJson(json, from)
    }


    fun format(json: String?): String? {
        var formattedString: String? = null
        if (json == null || json.trim { it <= ' ' }.length == 0) {
            throw FormatException("JSON layout_empty.")
        }
        try {
            if (json.startsWith("{")) {
                val jsonObject = JSONObject(json)
                formattedString = jsonObject.toString(4)
            } else if (json.startsWith("[")) {
                val jsonArray = JSONArray(json)
                formattedString = jsonArray.toString(4)
            } else {
                throw FormatException("JSON should start with { or [, but found $json")
            }
        } catch (e: Exception) {
            throw FormatException("Parse JSON error. JSON string:$json", e)
        }

        return formattedString
    }

}