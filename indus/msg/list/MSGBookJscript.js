
function shiftOption(from, to, fromNameText, toNameText, orderby, memList, resultArray)
{
	//if nothing is selected to add
	if(from.selectedIndex<0)
	{
		if (to.name=="bookAgents")
		{
			alert("Please Select a CLMS Member to add to your Member Book");
		}
		else
		{
			alert("Please Select a Member from your Member Book to remove");
		}
		from.focus();
		return;
	}
	
	// if nothing is given as a nick name
	if(trim(fromNameText.value).length==0)
	{
		alert("Please Specify a nick name for the Member");
		fromNameText.focus();
		return;
	}

	// if invalid nick name
	if(!validateNickName(fromNameText.value))
	{
		return;
	}

	val = from.options[from.selectedIndex].value.substr(0, from.options[from.selectedIndex].value.lastIndexOf("-"))+"-"+fromNameText.value.toLowerCase();
	
	if (to.name=="bookAgents")
		{
			// validates if ITS A GROUP LIST OR the nick name is already assigned to somebody
			if (orderby == 'NONE' || !ifExists(to , fromNameText.value.toLowerCase(), false) )
			{
				memList.value += val +"|";
				if (orderby == 'NICK')
				{
					txt = '("'+fromNameText.value.toLowerCase()+'")'+from.options[from.selectedIndex].text ;
				}
				else if (orderby == 'CLMS')
				{
					txt = from.options[from.selectedIndex].text +'("'+fromNameText.value.toLowerCase()+'")';
				}
				else
				{
					// Group List condition
					txt = from.options[from.selectedIndex].text;
				}
					var length = resultArray[0].length; // the old length of the array
					resultArray[0].length = resultArray[0].length +1;
					resultArray[1].length = resultArray[1].length +1;
					resultArray[0][length] = from.options[from.selectedIndex].value.substr(0, from.options[from.selectedIndex].value.lastIndexOf("-"));
					resultArray[1][length] = fromNameText.value.toLowerCase();

			}
			else
			{
				return;
			}
			
		}
	else
		{
			memList.value = memList.value.substr(0,memList.value.indexOf(val +"|"))+memList.value.substr(memList.value.indexOf(val +"|")+(val +"|").length);
			if (orderby == 'NICK')
			{
				txt = from.options[from.selectedIndex].text.substr(from.options[from.selectedIndex].text.indexOf(")")+1 );
			}
			else if (orderby == 'CLMS')
			{
				txt = from.options[from.selectedIndex].text.substr(0, from.options[from.selectedIndex].text.indexOf("(") );
			}
			else
			{
				//group list condition

				txt = from.options[from.selectedIndex].text;
			}
				
				var length = resultArray[0].length; // the old length of the array
				var shift = false; //to shift
				for (var y=0;y<=length ;y++ )
				{
					if (shift)
					{
						resultArray[0][y] = resultArray[0][y+1];
						resultArray[1][y] = resultArray[1][y+1];
					}
					else if (resultArray[0][y] == from.options[from.selectedIndex].text && resultArray[1][y] == fromNameText.value.toLowerCase())
					{
						shift = true;
						resultArray[0][y] = resultArray[0][y+1];
						resultArray[1][y] = resultArray[1][y+1];
					}
				}
				resultArray[0].length = length-1;
				resultArray[1].length = length-1;

		}
	to.focus();
	
	from.focus();
	from.options[from.selectedIndex] = null;
	
	to.length=to.length+1;
	to.options[to.length-1]=new Option(txt, val);
	to.selectedIndex = to.length-1;
	toNameText.value= fromNameText.value.toLowerCase();
	fromNameText.value = "";
}

function showNickName(fromSelect, toText)
{
	if(fromSelect.selectedIndex>-1)
	{
		var nickname = fromSelect.options[fromSelect.selectedIndex].value;
		toText.value = nickname.substr(nickname.lastIndexOf("-")+1 );
	}
}


function ifExists(fromSelect, nickNameVal, ignoreSelected)
{
	for(var i=0; i<fromSelect.options.length; i++)
	{
		if (trim(fromSelect.options[i].value.toLowerCase().substr(fromSelect.options[i].value.indexOf("-")+1)) == trim(nickNameVal.toLowerCase()))
		{

			if (ignoreSelected && fromSelect.options.selectedIndex==i )
			{
				continue;
			}
			else
			{
				alert('Member already added with the given nickname-'+fromSelect.options[i].value.replace('-','("')+'"), try giving some other nickname');
				
				return true;
			}
		}
	}
	return false;
}

function trim(s) 
{
	return s.replace(/^\s*/, '').replace(/\s*$/, '');
}

// edits the nick name
function editNickName(fromSelect, nickName, memList)
{
	if(trim(nickName.value).length ==0)
	{
		alert('Please specify a nick name for the member to edit');
		nickName.focus();
		return;
	}
	
	if(!validateNickName(nickName.value) || fromSelect.options.length==0 )
	{
		return;
	}
	var addVal = fromSelect.options[fromSelect.options.selectedIndex].value.substr(0,fromSelect.options[fromSelect.options.selectedIndex].value.indexOf("-")+1)+nickName.value.toLowerCase();

	if (!ifExists(fromSelect, nickName.value, true))
	{
		var removeVal = fromSelect.options[fromSelect.options.selectedIndex].value;
		//change the value
		fromSelect.options[fromSelect.options.selectedIndex].value = addVal; // the new val
	
		//remove the old value
		memList.value = memList.value.substr(0,memList.value.indexOf(removeVal +"|"))+memList.value.substr(memList.value.indexOf(removeVal +"|")+(removeVal +"|").length);
		//add the new val
		memList.value += addVal +"|";

		//change the text
		
		if (document.agentForm.orderby.value == 'NICK')
		{
			fromSelect.options[fromSelect.options.selectedIndex].text = '("'+nickName.value+'")'+
			fromSelect.options[fromSelect.options.selectedIndex].text.substr(fromSelect.options[fromSelect.options.selectedIndex].text.indexOf(")")+1);
		}
		else if (document.agentForm.orderby.value == 'CLMS')
		{
			fromSelect.options[fromSelect.options.selectedIndex].text = 
			fromSelect.options[fromSelect.options.selectedIndex].text.substr(0,fromSelect.options[fromSelect.options.selectedIndex].text.indexOf("(")+1)+'"'+nickName.value.toLowerCase()+'")';
		}
	
	}

}

function sort(order, targetSelect)
{
	var tmpVal='';
	var sorted = new Array();
	for(i=0;i<targetSelect.options.length;i++)
	{
		if(order == 'NICK')
		{
			tmpVal = '("'+targetSelect.options[i].value.substr(targetSelect.options[i].value.indexOf("-")+1)+'")';
			tmpVal += targetSelect.options[i].value.substr(0,targetSelect.options[i].value.indexOf("-"));
			tmpVal += '~'+targetSelect.options[i].value;
		}
		else if (order == 'CLMS')
		{
			tmpVal = targetSelect.options[i].value.substr(0,targetSelect.options[i].value.indexOf("-"));
			tmpVal += '("'+targetSelect.options[i].value.substr(targetSelect.options[i].value.indexOf("-")+1)+'")';
			tmpVal += '~'+targetSelect.options[i].value;
		}
		else
		{
			alert('Cannot sort for the given condition');
			break;//error condition--req parameter not coming
		}
		sorted[i] = tmpVal;
	}
	
	sorted.sort();

	for (i=0;i< sorted.length; i++)
	{
			targetSelect.options[i].text = sorted[i].substr(0, sorted[i].indexOf("~"));
			targetSelect.options[i].value = sorted[i].substr(sorted[i].indexOf("~")+1);
	}	

}

function validateNickName(nickNameVal)
{
var chkNick = nickNameVal;
	if(chkNick.indexOf('"')>-1 || chkNick.indexOf("'")>-1 || chkNick.indexOf('~')>-1 || chkNick.indexOf('#')>-1 || chkNick.indexOf('@')>-1 || chkNick.indexOf('$')>-1 || chkNick.indexOf('&')>-1 || chkNick.indexOf('|')>-1 ||chkNick.indexOf('\\')>-1 || chkNick.indexOf(',')>-1 || chkNick.indexOf('?')>-1 || chkNick.indexOf('^')>-1 || chkNick.indexOf('%')>-1 || chkNick.indexOf('-')>-1)
	{
		alert('The Nick Name contains invalid characters(",\'\\~@#$&?|^%-), please remove any such character and try again');
		return false;
	}
	else
	{
		return true;
	}

}

// populates the select with the array
function load(theSelect, theArray, nickName)
{
	var txt ='';
	theSelect.length =0;
	for (var index=0; index<theArray[0].length; index++)
	{
		if (nickName == '#')// no specific nick name means, populate all nick names
		{
			txt = theArray[0][index] + '("'+ theArray[1][index] + '")';
		}
		else// else load only for that particular nick name
		{
				if (theArray[1][index] != nickName)
				{
					continue;
				}
				txt = theArray[0][index] ;
		}

		theSelect.length=theSelect.length+1;
		theSelect.options[theSelect.length-1]=new Option(txt, theArray[0][index]+'-'+theArray[1][index]);
	}

}

function loadDifference(theSelect, theArray, theMinusArray, val)
{
	
	//theArray.sort();
	theMinusArray.sort();
	var minusIndex=0;
	theSelect.length=0;
	for (var index=0; index<theArray.length; index++)
	{
		if(theArray[index] == theMinusArray[minusIndex])
		{
			minusIndex ++;
		}
		else
		{
			theSelect.length=theSelect.length+1;
			//for address book the default nick name is agents name
			if (val=='#')
			{
				theSelect.options[theSelect.length-1]=new Option(theArray[index], theArray[index]+'-'+theArray[index]);
			}
			//for group list the default nick name is group name
			else
			{
				theSelect.options[theSelect.length-1]=new Option(theArray[index], theArray[index]+'-'+val);
			}
		}
	}
}

//loads the targetSelect from the source Array with the matching string that doesnot exist in minusArray
function reloadSelect(searchBox ,targetSelect, sourceArray, minusArray, nickName)
{
	minusArray.sort();
	var minusIndex=0;
	targetSelect.length=0;
	var val=nickName;
	for (var y=0; y<sourceArray.length; y++)
	{
		if(sourceArray[y] == minusArray[minusIndex])
		{
			minusIndex ++;
		}
		else
		{
			if(	sourceArray[y].indexOf(searchBox.value.toLowerCase())==0)
			{
				targetSelect.length=targetSelect.length+1;
				//for address book the default nick name is agents name
				if (val=='#')
				{
					targetSelect.options[targetSelect.length-1]=new Option(sourceArray[y], sourceArray[y]+'-'+sourceArray[y]);
				}
				//for group list the default nick name is group name
				else
				{
					targetSelect.options[targetSelect.length-1]=new Option(sourceArray[y], sourceArray[y]+'-'+val);
				}
			}//end of if anything matches
		}
		
	}
	
}

//used for donothing hyperlinks
function doNothing(){}