package com.xhd.td.data.remote

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName
import com.xhd.td.di.ApiInfo

import javax.inject.Inject
import javax.inject.Singleton

/**
 * Created by amitshekhar on 07/07/17.
 */

@Singleton
class ApiHeader @Inject
constructor(val publicApiHeader: PublicApiHeader, val protectedApiHeader: ProtectedApiHeader) {

    class ProtectedApiHeader(
        @Expose
        @SerializedName("api_key")
        var apiKey: String?,


        @Expose
        @SerializedName("access_token")
        var accessToken: String?
    )

    class PublicApiHeader @Inject constructor(@ApiInfo apiKey: String?){
        @Expose
        @SerializedName("api_key")
        var mApiKey = apiKey
    }
}
