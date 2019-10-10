<template>
  <div>
    <div class="full-app">
      <UploadFile v-if="screen === 'input-file'" @books-loaded="listBooks" :session-key="sessionKey" />

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
      sessionKey: null,
    }
  },
  components: {
    UploadFile,
    ListBooks,
    Loading,
  },
  mounted() {
    this.startSession();
  },
  methods: {
    startSession() {
      // if (!localStorage.sessionKey) {
      //   localStorage.sessionKey = this.makeId(20)
      // }

      // this.sessionKey = localStorage.sessionKey
      this.sessionKey = this.makeId(10)
    },
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
    },
    makeId(length) {
      var result           = '';
      var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      var charactersLength = characters.length;
      for ( var i = 0; i < length; i++ ) {
         result += characters.charAt(Math.floor(Math.random() * charactersLength));
      }
      return result;
    }
  },
}
</script>

<style scoped>


</style>
