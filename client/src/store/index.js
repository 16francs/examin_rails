import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

// 状態`Auth`と状態`Board`をVuexのstateで1限管理できるよう定義する
const state = {
}

export default new Vuex.Store({
  state, // 定義したstateを`state`オプションに指定
  strict: process.env.NODE_ENV !== 'production'
})
