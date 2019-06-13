<template>
  <div>
    <div class="full-app">
      <UploadFile v-if="screen === 'input-file'" @books-loaded="listBooks"/>

      <ListBooks v-if="screen === 'list-books'" :books="books"/>

<!--       <div v-if="screen === 'list-books'" class="app-list-books text-center">
        <h1 class="welcome-title">
          Here are the books contained in your clippings:
        </h1>

        <div class="each-book" v-for="book in books" @click="downloadBook(book.id)">
          <h1 class="book-name"> {{book.name}} </h1>
          <h2 class="book-highlights"> {{book.highlight_count}} </h2>
        </div>
      </div> -->
    </div>
  </div>
</template>

<script>
import UploadFile from 'pages/upload_file.vue'
import ListBooks from 'pages/list_books.vue'

export default {
  data: function () {
    return {
      screen: "input-file",
      books: [],
    }
  },
  components: {
    UploadFile,
    ListBooks,
  },
  methods: {
    listBooks(books) {
      console.log(books)
      this.screen = "list-books"
      this.books = books
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
