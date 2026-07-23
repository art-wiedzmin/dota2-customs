function TopNotification(msg) {
	AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
	AddNotification(msg, $('#BottomNotifications'));
}

function TopRemoveNotification(msg) {
	RemoveNotification(msg, $('#TopNotifications'));
}

function BottomRemoveNotification(msg) {
	RemoveNotification(msg, $('#BottomNotifications'));
}

function RemoveNotification(msg, panel) {
	if (panel.GetChildCount() > 0) {
		
		var count = msg.count;
		if (count != null && count > 0) {
			var start = panel.GetChildCount() - count;
			if (start < 0)
				start = 0;

			for (let i = start; i < panel.GetChildCount(); i++) {
				var lastPanel = panel.GetChild(i);
				// lastPanel.SetAttributeInt("deleted", 1);
				lastPanel.Data().deleted = true;
				lastPanel.DeleteAsync(0);
			}
		} else if (msg.text != null) {
			for (let i = 0; i < panel.GetChildCount(); i++) {
				var lastPanel = panel.GetChild(i);
				if (lastPanel.Data().textValue == msg.text) {
					lastPanel.Data().deleted = true;
					lastPanel.DeleteAsync(0);
				}

			}
		}
	}

}

function AddNotification(msg, panel) {
	var newNotification = true;
	var lastNotification = panel.GetChild(panel.GetChildCount() - 1)

	msg["continue"] = msg["continue"] || false;

	if (lastNotification != null && msg["continue"])
		newNotification = false;

	if (newNotification) {
		lastNotification = $.CreatePanel('Panel', panel, '');
		lastNotification.AddClass('NotificationLine')
		lastNotification.hittest = false;
		if (msg.text) { //只有新建的时候会记录文本内容，所以如果是拼接的语句，在删除的时候，只需要传入第一个就行了
			lastNotification.Data().textValue = msg.text
		}
		if (msg.error == 1) {
			lastNotification.SetHasClass("Error",true)
		}
	}
	
	var notification = null;

	if (msg.hero != null)
		notification = $.CreatePanel('DOTAHeroImage', lastNotification, '');
	else if (msg.image != null)
		notification = $.CreatePanel('Image', lastNotification, '');
	else if (msg.ability != null)
		notification = $.CreatePanel('DOTAAbilityImage', lastNotification, '');
	else if (msg.item != null)
		notification = $.CreatePanel('DOTAItemImage', lastNotification, '');
	else
		notification = $.CreatePanel('Label', lastNotification, '');

	if (typeof (msg.duration) != "number") {
		msg.duration = 3
	}

	if (newNotification) {
		$.Schedule(msg.duration, function() {
			if (lastNotification.deleted || !lastNotification.IsValid())
				return;

			lastNotification.DeleteAsync(0);
		});
	}

	if (msg.hero != null) {
		notification.heroimagestyle = msg.imagestyle || "icon";
		notification.heroname = msg.hero
		notification.hittest = false;
	} else if (msg.image != null) {
		notification.SetImage(msg.image);
		notification.hittest = false;
	} else if (msg.ability != null) {
		notification.abilityname = msg.ability
		notification.hittest = false;
	} else if (msg.item != null) {
		notification.itemname = msg.item
		notification.hittest = false;
	} else {
		notification.html = true;
		var text = msg.text || "No Text provided";
		if (msg.fmtKV) {
			for ( let key in msg.fmtKV) {
				var value = msg.fmtKV[key];
				if (typeof(value) == "number") {
					notification.SetDialogVariable(key,value)
				}else{
					notification.SetDialogVariable(key,$.Localize(value))
				}
			}
		}
		notification.text = $.Localize(text,notification)
		notification.hittest = false;
		notification.AddClass('TitleText');
	}
	
	if (msg["class"])
		notification.AddClass(msg["class"]);
	else
		notification.AddClass('NotificationMessage');

	if (msg.style) {
		for (let key in msg.style) {
			var value = msg.style[key]
			notification.style[key] = value;
		}
	}
}

(function() {
	GameEvents.Subscribe("top_notification", TopNotification);
	GameEvents.Subscribe("bottom_notification", BottomNotification);
	GameEvents.Subscribe("top_remove_notification", TopRemoveNotification);
	GameEvents.Subscribe("bottom_remove_notification", BottomRemoveNotification);
})();
