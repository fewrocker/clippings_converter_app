<template>
  <div>
    <div class="full-app">
      <div v-if="screen === 'input-file'" class="app-input-file text-center">
        <h1 class="welcome-title">
          Please upload you "my_clippings.txt" file below:
        </h1>
        <input type="file" ref="fileInput" @change="processFile($event)">
      </div>

      <div v-if="screen === 'list-books'" class="app-list-books text-center">
        <h1 class="welcome-title">
          Here are the books contained in your clippings:
        </h1>
        <ul>
          <li v-for="book in books"> {{book}} </li>
        </ul>

      </div>
    </div>

  </div>
</template>

<script>
export default {
  data: function () {
    return {
      screen: "input-file",
      message: "Hello Vue!",
      file: "",
      content: "",
      books: [],
    }
  },
  methods: {
    async processFile(event) {
      const vm = this

      const file = event.target.files[0];
      const reader = new FileReader();

      reader.onload = e => (vm.content = e.target.result);
      reader.readAsText(file);

      await this.$sleep(1000)

      axios({
        method: 'post',
        url: '/return_books',
        data: {
          content: vm.content,
        }
      }).then(function (res) {
        console.log(res.data.books)
        vm.books = res.data.books
        vm.screen = "list-books"
      })
    },
  },
}
</script>

<style scoped>


</style>
