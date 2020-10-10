<?php include_once('header.php');?>
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
function deleteMenu(id, menuId){
	if(confirm('해당 메뉴를 삭제하겠습니까?')){
		location.href='delete.php?cate=board&id='+ id + '&menuId='+menuId;
	}
}
function winOpen(url, moveFlag){
	if(moveFlag == 1){
		window.open(url);
	}else{
		location.href=url;
	}
}
function goUrl(url, type, boardId, menu, moveFlag){
	$.ajax({
    url: "updateCnt.php",
    type: "POST",
    cache: false,
    data: {'boardId' : boardId},
    success: function(data){
		  if(type == '1'){
				winOpen(url, moveFlag);
		  }else if(type == '2'){
				location.href='getBoard.php?menu='+menu+'&boardId='+boardId;
		  }
    },
    error: function (request, status, error){ 
		  var msg = "ERROR : " + request.status + "<br>"
		  msg +=  + "내용 : " + request.responseText + "<br>" + error;
		  console.log(msg);              
    }
  });
}
var block = 8;
var conNum = 16;
var start = conNum;
var end = start+block;
var search = $('#search').val();
var menuId = 0;
var url = document.location.href;
var astr = url.split('/');
var astr2 = astr[3].split('menu=');
var scrollFlag = false;

if(astr2.length == 1){
	menuId = 1;
}
else{
	var astr3 = astr2[1].split('&')[0];
	menuId = astr3;
}

<?php
	if($_SESSION["user_id"] != "admin"){
?>
$(window).scroll(function() {
	if(start%block == 0){
		if ($(window).scrollTop() >= $(document).height() - $(window).height() - 20 && scrollFlag == false) {
			scrollFlag = true;
			$('#buf').css("display", "inline");
			setTimeout(function(){
				$.ajax({
					url: "getBoardList.php",
					type: "POST",
					cache: false,
					//dataType: "json",
					data: {'search' : search, 'menuId' : menuId, 'start' : start, 'end' : end},
					success: function(data){
						data = JSON.parse(data);
						if(data != null){
							$.each(data, function(index, board){
								++conNum;
								$('.col-md-3#'+(conNum-1)).after('<div class="col-md-3" id="'+conNum+'"><div class="box-pointer" onclick="goUrl(\''+board.url+'\', \''+board.type+'\', \''+board.id+'\', \''+board.menuId+'\', \''+board.moveFlag+'\')"><img class="box-content" src="'+board.img+'"/><h5>'+board.nm+'</h5></div><p>'+board.tag+'</p></div>');
							});
							start = conNum;
							end = start+block;
							setTimeout(function(){$('#buf').css("display", "none")}, 1000);
						}
						else if(start%block == 0 || data == null){
							scrollFlag = true;
							$('#buf').css("display", "none");
						}
					},
					error: function (request, status, error){ 
						  var msg = "ERROR : " + request.status + "<br>"
						  msg +=  + "내용 : " + request.responseText + "<br>" + error;
						  console.log(msg);              
					}
				});
			}, 1000);
		}
	}
});
<?php
}
?>
</script>
<?php
$sql = "select * from time_main where id>1 order by id";
$res = mysqli_query($conn, $sql);
for($i=0;$row=mysqli_fetch_array($res);$i++){
	$arr_mainlist[$i] = array($row['id'], $row['url'],  $row['img']);
}
?>

<div class="row">
	<div class="col-md-6">
		<img class="mainimg" src="<?=$arr_mainlist[0][2]?>" onclick="location.href='<?=$arr_mainlist[0][1]?>'"/>
	</div>
	<div class="col-md-6">
		<img class="mainimg" src="<?=$arr_mainlist[1][2]?>"  onclick="location.href='<?=$arr_mainlist[1][1]?>'"/>
	</div>
</div>
<div class="row">
<?php
$search = $_GET['search'];

if($_SESSION["user_id"] == "admin"){
	$sql = "select * from time_board where menuId = $menu order by cnt desc";
}else{
	if($search == '')
		$sql = "select * from time_board where menuId = $menu order by cnt desc limit 0, 16";
	else
		$sql = "select * from time_board where tag like '%$search%' or nm like '%$search%' order by cnt desc limit 0, 16";
}
$res = mysqli_query($conn, $sql);
for($i=1;$row=mysqli_fetch_array($res);$i++){
?>
<div class="col-md-3" id="<?=$i?>">
		<div class="box-pointer" onclick="goUrl('<?=$row['url']?>', '<?=$row['type']?>', '<?=$row['id']?>', '<?=$row['menuId']?>', '<?=$row['moveFlag']?>')">
			<img class="box-content" src="<?=$row['img']?>"/>
			<h5><?=$row['nm']?></h5>
		</div>
		<p><?=$row['tag']?></p>
<?php
	if($_SESSION["user_id"] == "admin"){
?>		
		<div class="text-center">
			<a href="insertBoard.php?menu=<?=$row['menuId']?>&boardId=<?=$row['id']?>" class="btn board" style="width:30%">변경</a>
			<a href="javascript:deleteMenu('<?=$row['id']?>', '<?=$row['menuId']?>')" class="btn btn-danger" style="width:30%">삭제</a>
		</div>
<?php
	}
?>
	</div>
<?php
}
?>
	<div class="buf">
		<img src="img/main/buf.gif" id="buf" class="bufImg"/>
	</div>
</div>

<?php include_once('footer.php');?>