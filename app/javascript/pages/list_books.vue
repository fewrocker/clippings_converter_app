<template>
  <div>
    <div class="full-app app-list-books">
      <div>
        <h1 class="page-title">
          Here are the books contained in your clippings
        </h1>
        <h1 class="page-description">
          Click on a book to download a .docx containing all your highlights
        </h1>


        <div class="all-books">
          <div class="each-book" v-for="book in books" @click="downloadBook(book.id)">
            <h1 class="book-name"> {{book.name}} </h1>
            <h2 class="book-highlights"> {{book.highlight_count}} highlights</h2>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "ListBooks",
  data: function () {
    return {

    }
  },
  props: ['books'],
  methods: {
    async downloadBook(bookId) {
      const res = await axios({
        method: 'post',
        url: '/return_highlights',
        data: {
          id: bookId,
        }
      })

      window.open(res.data.book_url, '_blank');
    }
  },
}
</script>

<style scoped>
  .page-title {
    margin-bottom: 10px;
    font-size: 20px;
    color: black;
    font-weight: bold;
    font-family: 'Helvetica';
    text-align: left;
  }

  .page-description {
    margin-bottom: 30px;
    font-size: 16px;
    color: black;
    font-family: 'Helvetica';
    text-align: left;
  }

</style>
