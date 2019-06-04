<template>
  <div>
    <p>{{ message }}</p>

    <input type="file" ref="fileInput" @change="processFile($event)">
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!",
      file: "",
      content: "",
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
        console.log(res.data)
      })

    },
  },
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
