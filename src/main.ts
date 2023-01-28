const navtabs: [string, string][] =
[
	/* [name, file path relative to root] */
	["binds", "./html/tabs/binds.html"],
	["test", "./html/tabs/test.html"],
];

function createTabs(): void
{
	const w = document.getElementById("cfg-nav-wrapper");
	const tabs = document.createElement("div");
	const panels = document.createElement("div");
	const sheet = document.styleSheets[0];

	panels.className = "panels";
	tabs.className = "tabs";

	if(!w)
		throw "no nav wrapper :(";

	w.appendChild(tabs);
	w.appendChild(panels);

	for(let i in navtabs)
	{
		const nt = navtabs[i];
		const btn = document.createElement("input");
		const t = document.createElement("label");
		const p = document.createElement("div");

		btn.type = "radio";
		btn.id = `btn_${i}`;
		btn.name = "group";
		btn.className = "radio";

		t.id = `tab_${i}`;
		t.htmlFor = btn.id;
		t.className = "tab";
		t.innerText = nt[0];

		p.id = `panel_${i}`;
		p.className = "panel";

		/* temp */
		p.innerText = `hi :3 ${i}`

		sheet.insertRule(`#btn_${i}:checked ~ .panels #panel_${i}\
						 {display:block}`);

		sheet.insertRule(`#btn_${i}:checked ~ .panels #panel_${i}\
						 {border-bottom: 3px inset theme.$text; \
						 margin-bottom: 6px;}`);

		w.appendChild(btn);
		tabs.appendChild(t);
		panels.appendChild(p);
	}
}

function main(): void
{
	console.log("hi");
	createTabs();
}

main();
