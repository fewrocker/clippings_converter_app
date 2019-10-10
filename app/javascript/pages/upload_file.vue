<!-- https://alligator.io/vuejs/vue-dropzone/ -->

<template>
  <div>
    <div class="full-app">
      <div v-if="loading">
        <Loading />
      </div>
      <div v-else>


        <h1 class="welcome-title">
          Please upload you "my_clippings.txt" file below:
        </h1>
        <input type="file" ref="fileInput" @change="processFile($event)">
      </div>
    </div>
  </div>
</template>

<script>
import vue2Dropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
import Loading from '../components/loading.vue'

export default {
  name: "UploadFile",
  data: function () {
    return {
      content: "",
      loading: false,
      dropzoneOptions: {
        url: 'https://httpbin.org/post',
        thumbnailWidth: 300,
        maxFilesize: 0.5,
        maxFiles: 1,
        acceptedFiles: "application/txt",
      }
    }
  },
  props: [ "sessionKey" ],
  components: {
    vueDropzone: vue2Dropzone,
    Loading,
  },
  methods: {
    async addedFile(file) {
      const vm = this

      this.loading = true

      const reader = new FileReader();

      reader.onload = e => (this.content = e.target.result);
      reader.readAsText(file);

      await this.$sleep(1000)

      const res = await axios({
        method: 'post',
        url: '/return_books',
        data: {
          content: this.content,
          session_key: this.sessionKey,
        }
      })

      this.loading = false

      this.$emit('books-loaded', res.data.books)
    },
    async processFile(event) {
      const vm = this

      this.loading = true

      const file = event.target.files[0];
      const reader = new FileReader();

      reader.onload = e => (this.content = e.target.result);
      reader.readAsText(file);

      await this.$sleep(1000)

      const res = await axios({
        method: 'post',
        url: '/return_books',
        data: {
          content: this.content,
          session_key: this.sessionKey,
        }
      })

      this.loading = false

      console.log(res.data.books)
      this.$emit('books-loaded', res.data.books)
    },
  },
}
</script>

<style scoped>


</style>
