<template>
  <div>
    <div class="full-app">
      <div v-if="loading">
        <h1>
          Your file is loading...
        </h1>
      </div>
      <div v-else="loading">
        <h1 class="welcome-title">
          Please upload you "my_clippings.txt" file below:
        </h1>
        <input type="file" ref="fileInput" @change="processFile($event)">
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: "UploadFile",
  data: function () {
    return {
      content: "",
      loading: false,
    }
  },
  methods: {
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
