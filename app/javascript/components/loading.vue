<template>
  <transition name="fade">
    <div class="loading">
      <div class="icon-loading">
        <svg class="icon">
          <symbol id="loading-animation" viewBox="0 0 100 100">
            <circle cx="50" cy="50" r="27" fill="none" stroke="#a5a5a5" stroke-width="8" stroke-dasharray="21.2 169.6" stroke-linecap="round" />
            <circle cx="50" cy="50" r="27" fill="none" stroke="#999999" stroke-width="8" stroke-dasharray="21.2 169.6" stroke-linecap="round" transform="rotate(90 50 50)" />
            <circle cx="50" cy="50" r="27" fill="none" stroke="#a5a5a5" stroke-width="8" stroke-dasharray="21.2 169.6" stroke-linecap="round" transform="rotate(180 50 50)" />
            <circle cx="50" cy="50" r="27" fill="none" stroke="#999999" stroke-width="8" stroke-dasharray="21.2 169.6" stroke-linecap="round" transform="rotate(270 50 50)" />
          </symbol>

          <use href="#loading-animation" xmlns:xlink="http://www.w3.org/1999/xlink"/>
        </svg>
      </div>
      <h3 class="loading-title">Your file is loading</h3>
    </div>
  </transition>
</template>

<script>
  export default {
    name: "Loading",
    props: {
      full: {
        type: Boolean,
        default: false,
      },
      noBackground: {
        type: Boolean,
        default: false,
      },
      whiteMask: {
        type: Boolean,
        default: false,
      },
    },
  };
</script>

<style lang="scss" scoped>
  // @import "base/variables";

  .loading {
    align-items: center;
    background: rgba(white, 0.5);
    bottom: 0;
    display: flex;
    justify-content: center;
    flex-direction: column;
    left: 0;
    position: absolute;
    right: 0;
    top: 0;
    will-change: transform;
    z-index: 1;
    .icon {
      animation: spin 3s infinite linear;
      height: 250px;
      width: 250px;
    }
  }

  @keyframes spin {
    to { transform: rotate(0deg); }
    from { transform: rotate(-360deg); }
  }

  .loading-title {
    color: #999;
    font-size: 22px;
  }
</style>
