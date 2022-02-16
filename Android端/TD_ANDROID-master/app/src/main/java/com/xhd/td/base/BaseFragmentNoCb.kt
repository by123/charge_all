package com.xhd.td.base

import androidx.databinding.ViewDataBinding

/**
 * Created by amitshekhar on 09/07/17.
 */

abstract class BaseFragmentNoCb<T : ViewDataBinding,V : BaseViewModelNoCb> : BaseFragment<T ,V,NullInterface>()
interface NullInterface
