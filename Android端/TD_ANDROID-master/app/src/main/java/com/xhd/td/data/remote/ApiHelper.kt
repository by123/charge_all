package com.xhd.td.data.remote

import com.xhd.td.net.HttpService

/**
 * Created by amitshekhar on 07/07/17.
 */

interface ApiHelper {

    //    Single<LogoutResponse> doLogoutApiCall();
    //    Single<LoginResponse> doServerLoginApiCall(LoginRequest.ServerLoginRequest request);
    val apiHeader: ApiHeader

    val httpService: HttpService
}
