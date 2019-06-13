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

        <div class="each-book" v-for="book in books" @click="downloadBook(book.id)">
          <h1 class="book-name"> {{book.name}} </h1>
          <h2 class="book-highlights"> {{book.highlight_count}} </h2>
        </div>
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

      this.books = res.data.books
      this.screen = "list-books"
    },

    async downloadBook(bookId) {
      const res = await axios({
        method: 'post',
        url: '/return_highlights',
        data: {
          id: bookId,
        }
      })

      console.log(res.data)

      window.open(res.data.book_url, '_blank');
    }
  },
}
</script>

<style scoped>


</style>
