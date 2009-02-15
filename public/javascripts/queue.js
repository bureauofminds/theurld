function addLink(queue_id, index, size) {
  if (index <= size) {
    // I'm not sure how to get onFailure working yet
    new Ajax.Request('/links/queue/'+queue_id+'/'+index, {asynchronous:true, evalScripts:true, onLoading:updateStatus(index, 'loading'), onComplete:function(request){updateStatus(index, 'success'); if ((index + 1) == size) {window.location = '/';} if (index < size) {index++; addLink(queue_id, index, size);}}});
  }
}

function updateStatus(index, status) {
  span = $('url_status_' + index);
  if (status == "loading") {
    span.innerHTML = "Loading";
    span.className = 'loading';
    
  } else if (status == "success") {
    span.innerHTML = "Success";
    span.className = 'success';
    
  } else if (status == "failure") {
    span.innerHTML = "Failure";
    span.className = 'failure';
  }
}