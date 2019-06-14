<template>
  <div>
    <div class="full-app">
      <UploadFile v-if="screen === 'input-file'" @books-loaded="listBooks"/>

      <ListBooks v-if="screen === 'list-books'" :books="books"/>
    </div>
  </div>
</template>

<script>
import UploadFile from 'pages/upload_file.vue'
import ListBooks from 'pages/list_books.vue'
import Loading from 'components/loading.vue'

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
    Loading,
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
