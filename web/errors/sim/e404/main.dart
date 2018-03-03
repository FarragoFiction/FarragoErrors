import "dart:async";
import 'dart:html';

import "package:RenderingLib/RendereringLib.dart";

Element chat;
TextInputElement textbox;

List<String> toWrite = <String>[];
List<String> toRead = <String>[];
bool busy = false;

void main() {
    DateTime loadtime = new DateTime.now();
    querySelector("#time").text = "${loadtime.hour.toString().padLeft(2, "0")}:${loadtime.minute.toString().padLeft(2, "0")}";

    chat = querySelector("#chat");
    textbox = querySelector("#textbox");

    querySelector("#pester")
        ..onClick.listen(send_chat);
    textbox
        ..onKeyPress.listen((KeyboardEvent e) {
            if (e.keyCode == 13) {
                send_chat();
            }
        });

    querySelector("#arrowcontainer")
        ..onClick.listen((MouseEvent e){
            window.history.back();
        });

    textbox.focus();

    intro();
}
//###############################

Map<String, int> memory = <String,int>{};

int getMemory(String subject) {
    if (!memory.containsKey(subject)) {
        return 0;
    }
    return memory[subject];
}

void addMemory(String subject) {
    if (!memory.containsKey(subject)) {
        memory[subject] = 1;
    } else {
        memory[subject] = memory[subject] + 1;
    }
    //print(memory);
}

void intro() {
    pl_write(rand.pickFrom(<String>[
        "hey",
        "hey",
        "hey",
        "hey",
        "hey, dunkass",
        "hey, you",
        "...",
        "woah",
        "!",
        "woah, hold up a second",
        "hang on a second",
        "what are...",
    ]));
    pl_write(rand.pickFrom(<String>[
        "you're not supposed to be here",
        "you shouldn't be here",
        "you shouldn't be back here",
        "you get lost or something?",
        "you're not meant to see this place",
        "you're not meant to be here",
        "why are you back here?",
        "what are you doing back here?",
        "what the heck are you doing?",
        "why are you here? You shouldn't be."
    ]));

    String subject = getSubject(window.location.pathname, true);

    if (subject == "[???]") { // ??? puzzle
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["what's this...", "are you looking for puzzle answers?"],
            <String>["is that three question marks I see?"],
            <String>["hmm", "so that's it eh?"],
            <String>["well, look at that, seeking answers."],
            <String>["ah, an easter egg hunter I see..."],
            <String>["trying to find more hints to the [???] page?"],
        ]));
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["not gonna happen, sorry", "wrong place for that. No clues."],
            <String>["you're not getting anything from me. Secrets are secrets!"],
            <String>["you might wanna look at that clue more carefully if you ended up here"],
            <String>["nope", "not happening", "you have to earn your puzzle rewards"],
            <String>["you're not paying attention to the clue if you're here."],
            <String>["well...", "maybe try reading the clue better. You're not gonna find anything here."],
        ]));
    } else if (subject == "loras") { // rods and screens
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["hm, so it's LORAS is it?"],
            <String>["ah, that looks like you're looking for LORAS hints"],
            <String>["hmm", "is that LORAS stuff you're looking for?"],
            <String>["ah, is this about the Land of Rods and Screens?"],
            <String>["LORAS. I see..."],
            <String>["it looks like you're trying to find hints for LORAS"],
        ]));
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["well, you won't find any clues here, it's self-contained"],
            <String>["everything you need to solve it is on the page already"],
            <String>["you don't need to look anywhere else for answers"],
            <String>["nice try", "thing is, all the info is on the page"],
            <String>["a nice thought, but everything you need is already on the page"],
            <String>["it's self-contained - you don't need anything else to solve it"],
        ]));
    } else if (subject == "shogun") { // who is shogun???
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["oh, you wanna know about shogun do you?"],
            <String>["trying to find out who shogun is, I see"],
            <String>["oh, hah, I see", "trying to work out who shogun is then?"],
            <String>["hmm, you wanna know who shogun is", "I see"],
            <String>["oh boy, you want to know the answer to \"who is shogun???\""],
            <String>["ah, looking for shogun hints then..."],
        ]));
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["well, tough luck", "not gonna spoil his carefully laid plans"],
            <String>["too bad, not gonna tell", "dude's a dear friend, not gonna give away secrets like that"],
            <String>["pff, not a chance. I'm not gonna spoil stuff, and especially not that"],
            <String>["I'll let you in on a secret", "I never solved it myself, didn't want the frustration", "good luck, though!"],
            <String>["nice try, but no", "I'm not gonna spoil that one, no way"],
            <String>["you're gonna have to try harder than that", "since, well, you're pretty clearly in the wrong place"],
        ]));
    } else if (subject == "numbers") { // who is shogun??? but numbers
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["hm, I see a load of numbers","I think I know what you might be trying to guess..."],
            <String>["ohhh, numbers numbers numbers", "doesn't look like you got the right one, though..."],
            <String>["oh dear, so near yet so far", "seems you guessed the wrong number."],
            <String>["...", "oh", "all these numbers and it wasn't the right one..."],
            <String>["oh, wait, right... heh", "tisk tisk, looks like your numbers are wrong."],
            <String>["huh...", "numbers?", "looking for something, are we?", "well, seems you got it wrong!"],
        ]));
    } else { // generic hello
        pl_write_multi(rand.pickFrom(<List<String>>[
            <String>["hmm...", "you might wanna look elsewhere"],
            <String>["I put some links down below that might help you find whatever it was you were looking for"],
            <String>["as such", "you might wanna leave"],
            <String>["are you trying to snoop around?", "...", "actually, forget I asked"],
            <String>["what on earth are you trying to look for..."],
            <String>["shit, was it a broken link?", "if yes, you should report that."],
            <String>["check the links below if you're lost."],
            <String>["if you're lost there's some links down there to get around"],
            <String>["...", "welcome to the void, I guess?"],
        ]));
    }

    if (subject != null) {
        addMemory(subject);
    }
}

List<List<List<String>>> chatResponses = <List<List<String>>>[
    <List<String>>[ // first reply
        <String>["..."],
        <String>["hm"],
        <String>["hmmm"],
        <String>["uh..."],
    ],
    <List<String>>[ // second
        <String>["look, this is great and all", "but it's not *interesting*"],
        <String>["you could ask anything", "and you say that..."],
        <String>["come on... ask something fun"],
        <String>["perhaps if you asked something interesting", "you'd get an answer"],
    ],
    <List<String>>[ // third
        <String>["right..."],
        <String>["..."],
        <String>["...", "hm"],
        <String>["sure..."],
    ],
    <List<String>>[ // fourth
        <String>["ugh", "this is getting boring"],
        <String>["hmph", "you gonna ask anything relevant?"],
        <String>["snore", "'bout ready to fall asleep here"],
        <String>["this is getting boring", "got anything good to ask?"],
    ],
    <List<String>>[ // fifth
        <String>["really?"],
        <String>["sigh...", "come on"],
        <String>["laaame"],
        <String>["..."],
    ],
    <List<String>>[ // sixth
        <String>["I'm just gonna ignore you now", "unless you ask the right stuff of course..."],
        <String>["nah, this is going nowhere", "ask something interesting or I'm out"],
        <String>["look, I've got things to be doing", "ask something good or don't bother"],
        <String>["if you're not going to be asking anything interesting", "I'm just gonna go do something else..."],
    ],
];

void process_reading(String text) {
    String subject = getSubject(text);
    //print(subject);

    if (subject == "[???]") {
        if (getMemory("[???]") == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["I already told you", "you're not getting any hints"],
                <String>["just... look at the clue", "it tells you everything you need to find the answer"],
                <String>["no, no, no", "if you ended up here you're not looking in the right place", "read the clue again"],
            ]));
        } else if (getMemory("[???]") == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["ah, so you're looking for puzzle clues", "you're in the wrong place", "pay attention to what you're told"],
                <String>["hm", "so you're trying to get into [???] then I see", "well, you're in the wrong place"],
                <String>["you're in the wrong place for [???] stuff", "pay more attention to the clue"],
                <String>["you're gonna need to read the clue better if you ended up here", "read it *carefully*"],
                <String>["you're looking in the wrong place", "go back and read more carefully"],
                <String>["right, [???] clues...", "you already have the clue you need", "pay more attention to it"],
            ]));
        }
    } else if (subject == "loras") {
        if (getMemory("loras") == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["I already said", "there's nothing outside of the page", "it has everything you need to solve the puzzle"],
                <String>["you're not listening", "everything needed is on the page"],
                <String>["I said this already...", "there's nothing more about LORAS outside the page", "it's all on there, everything you need"],
            ]));
        } else if (getMemory("loras") == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["ah, trying to solve LORAS", "you don't need anything outside the page", "it has everything you need already"],
                <String>["LORAS is it?", "well, the thing is...", "everything you need to win is already on the page"],
                <String>["solving LORAS are you?", "well, you're not gonna need anything here", "everything you need is there already"],
                <String>["LORAS... ok, well, you see...", "you don't need anything from anywhere else on the site", "the page has it all already"],
                <String>["defeating Janus is no simple task", "but everything you need to win is on the LORAS page", "you don't need to search the site"],
                <String>["LORAS is a tricky one", "but you don't need anything from the rest of the site", "it's allll on the page already"],
            ]));
        }
    } else if (subject == "shogun") {
        if (getMemory("shogun") == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["stop asking", "you're not getting anything from me about it"],
                <String>["will you stop asking?", "I'm not gonna spoil the puzzle", "you need to work it out yourself"],
                <String>["no, just... no", "not gonna give anything about shogun's puzzle away"],
            ]));
        } else if (getMemory("shogun") == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["you wanna know who Shogun is?", "...", "a pretty cool guy.", "... that's not the answer"],
                <String>["nope, you're not getting any clues to that one", "not gonna betray that trust"],
                <String>["ah, that puzzle...", "it's a tough one for sure", "too bad I'm not gonna tell you anything"],
                <String>["here's a little secret: I never solved it myself", "couldn't be bothered with the frustration", "good luck trying, though!"],
                <String>["Shogun is a good friend of mine", "...", "oh, you meant the puzzle? nah, no clues"],
                <String>["Shogun is many things...","rampaging murderer", "powerful warrior", "shogun of sauce", "very tall", "secret cinnamon roll", "...huggable", "actually, uh", "forget I said those last two, would you?"],
            ]));
        }
    } else if (subject == "jr") {
        if (getMemory("jr") == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["I already said, Author, sim maker etc etc."],
                <String>["you should know by now... don't make me repeat myself"],
                <String>["you already asked that, don't be dumb"],
            ]));
        } else if (getMemory("jr") == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["JR is the Author", "the creator and lead programmer of SBURBSim", "and one of the coolest people I know"],
                <String>["JR created the sim, and gave me the opportunity to work on it too", "which is something I am eternally thankful for", "it's the best project I've ever worked on...", "it's honestly changed my life"],
                <String>["gigglesnort incarnate", "but nah, really, JR loves those easter eggs", "the sim wouldn't be the same without 'em"],
                <String>["JR is the creator of the sim, the Author", "they program at super-speed, churning out new features like you wouldn't believe", "it's hella impressive"],
                <String>["JR is the Waste of Mind, and Author of the sim", "lead programmer and lightspeed writer of all things code", "and a really good friend"],
                <String>["jadedResearcher...", "Author", "easter egg addict", "responsible for the death of sextillions", "turbo-speed programmer", "king bun of the SBURBSim team", "and a super supportive friend"],
            ]));
        }
    } else if (subject == "kr") {
        if (getMemory("kr") == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["don't let KR know you weren't listening first time"],
                <String>["careful - you don't want KR finding out you weren't paying attention first time round"],
                <String>["I'll... just pretend you didn't ask again, for your own sake", "don't tell KR"],
            ]));
        } else if (getMemory("kr") == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["KR is the Artist", "overseer of SBURBSim's art assets", "and a champion of good taste"],
                <String>["KR was the second to join the sim team", "they make sure that the sim doesn't burn out your eyes", "most of the time anyway...", "sometimes it's deliberate"],
                <String>["a memester of superlative taste", "for real though, KR is the sim's voice of reason", "JR would have gotten away with all sorts of crimes without their influence"],
                <String>["buff", "just, so buff", "the most buff. KR will knock you the fuck out with their immense muscles", "while also only being slightly less smol than JR is", "KR is terrifyingly dense - do not cross them"],
                <String>["KR is the sim's voice of reason", "also the wielder of the banhammer and defender of good taste", "(and of course also a very good artist)"],
                <String>["karmicRetribution, let's see...", "Artist", "eternal defender of good taste", "just, the buffest", "like, so buff", "guardian of the banhammer", "Smith of Dream", "second smollest", "memester of transcendent sensibility"],
            ]));
        }
    } else if (subject == "pl") {
        if (getMemory("pl") == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["aw come on, don't be a dick about it", "I already said"],
                <String>["hey, cut that shit out, I just told you"],
                <String>["hey, no need to act dumb", "I did just tell you after all"],
            ]));
        } else if (getMemory("pl") == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["I am the Architect", "programmer and technical artist for SBURBSim", "I write a lot of tools and do graphics programming"],
                <String>["I was the third to join the sim team", "the first IdeasWrangler to contribute enough to ascend", "mostly through the Great Refactoring, where we switched from javascript to dart", "that was a nightmare, but totally worth it!"],
                <String>["I program tools and systems for the sim", "I also do graphics stuff which is too arty for JR and too technical for KR", "oh, and I draw a lot of lands, too"],
                <String>["\"best at void\" - it just keeps happening", "a lot of the things I write for the sim are behind the scenes", "tools and utilities which help JR go even faster", "or organise the code a bit better and make working with it simpler"],
                <String>["just an echo in the void", "I'm not real", "well... the real PL would probably answer questions the same", "but hey, they're not here right now", "so it's just me"],
                <String>["me? oh, uh...", "Architect", "Witch of Void", "good at painting lands", "able to keep up with JR's programming speed", "(ir)responsible adult", "second tallest", "and, according to popular opinion, \"thicc\"", "...", "maybe forget that last one"],
            ]));
        }
    } else if (subject == "va") {
        if (getMemory("va") == 0) {
            pl_write("super cute <3");
        }
    } else if (subject.startsWith("wrangler_")) {
        String name = subject.substring(9).toUpperCase();
        if (getMemory(subject) == 1) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["I already told you about $name"],
                <String>["come on, pay attention, you already asked about $name"],
                <String>["you already asked about $name, keep up"],
            ]));
        } else if (getMemory(subject) == 0) {
            pl_write_multi(rand.pickFrom(<List<String>>[
                <String>["$name is one of the IdeasWranglers", "they provide ideas, designs, or other info in volume which is useful for making the sim"],
                <String>["ah, $name. They're one of the IdeasWranglers", "the IWs come up with detailed designs or other meaningful information for the sim"],
                <String>["$name, yes, one of the IdeasWranglers", "they hold the title for doing enough design work to have significantly contributed"],
                <String>["yeah, they're one of the IWs", "as one of the IdeasWranglers, $name helps us design the sim", "their ideas were significant enough that they changed the sim"],
                <String>["$name is one of the IdeasWranglers", "and a good friend, to boot"],
                <String>["oh, yeah, $name is a pretty cool person", "one of the IdeasWranglers, big contributors to sim development"],
                <String>["$name is a cool guy", "contributes to the sim and doesn't afraid of anything"],
                <String>["$name has contributed to the sim, which is really cool", "enough to be considered an IdeasWrangler"],
                <String>["$name is a good friend", "and contributed to the sim", "so much that they're one of the IdeasWranglers"],
                <String>["one of the IdeasWranglers", "$name contributed designs or ideas to the sim which were useful enough to be added"],
            ]));
        }
    } else if (subject == "chat") {
        int count = getMemory("chat");
        if (count >= chatResponses.length) { return; }
        List<List<String>> responses = chatResponses[count];

        pl_write_multi(rand.pickFrom(responses));
    }

    if (subject != null) {
        addMemory(subject);
    }
}

//###############################

void pl_write(String text) {
    toWrite.add(text);

    writeloop();
}

void pl_write_multi(List<String> text) {
    for (String t in text) {
        pl_write(t);
    }
}

Random rand = new Random();
const Duration ms = const Duration(milliseconds: 1);
void writeloop() {
    if (busy) {
        return;
    }
    busy = true;

    if (!toWrite.isEmpty) {
        String text = toWrite.removeAt(0);

        // add some variance so it's +/- 10ms per character

        int variance = 0;
        for (int i=0; i<text.length; i++) {
            variance -= 10;
            variance += rand.nextInt(20);
        }

        new Timer(ms * (110 * (text.length + 6) + variance), (){
            pl_text(text);
            busy = false;
            writeloop();
        });

        return;
    }

    if (!toRead.isEmpty) {
        String text = toRead.removeAt(0);

        new Timer(ms * 30 * (text.length + 1), (){
            process_reading(text);
            busy = false;
        });
    }

    busy = false;
}

Map<String, List<String>> wranglers = <String, List<String>>
{
    "aw": <String>["aw", "aspiringwatcher"],
    "sb": <String>["sb", "somebody", "secondbrain", "brope", "the brope"],
    "io": <String>["io", "insufferableoracle"],
    "tg": <String>["tg", "tableguardian"],
    "mi": <String>["mi", "manicinsomniac"],
    "rs": <String>["rs", "recursiveslacker"],
    "dm": <String>["dm", "dilletantmathematician"],
    "wm": <String>["wm", "woomod"],
};
RegExp punctuationpattern = new RegExp("[.,\/#!%\^&\*;:{}=\-_`~\(\)]");
String getSubject(String input, [bool url = false]) {
    String processed = input.toLowerCase().replaceAll(punctuationpattern, " ");
    List<String> words = processed.split(" ")..retainWhere((String s) => s.isNotEmpty);

    //print(processed);
    //print(words);

    //return "[???]"; // for testing responses to url

    if (processed.contains("better than expected") || processed.contains("[???]") || processed.contains("???")) {
        return "[???]";
    }

    if (url && (processed.contains("expected") || processed.contains("better"))) {
        return "[???]";
    }

    if (processed.contains("loras") || processed.contains("janus") || processed.contains("rods")) {
        return "loras";
    }

    if (processed.contains("who is shogun")) {
        return "shogun";
    }

    if (url && !words.isEmpty) {
        int n = int.parse(words.last, onError: (String input) => -1);
        if ((!processed.contains("seed")) && !words.last.startsWith("-") && words.last.length > 1 && n >= 0) {
            return "numbers";
        }
    }

    if (!url) {
        if(processed.contains("who is jr") || processed.contains("who is jadedresearcher")) {
            return "jr";
        }

        if(processed.contains("who is kr") || processed.contains("who is karmicretribution")) {
            return "kr";
        }

        if(processed.contains("who are you") || processed.contains("who is pl") || processed.contains("who is paradoxlands")) {
            return "pl";
        }

        if (processed.contains("who is va") || processed.contains("who is viralamore")) {
            return "va";
        }

        for (String wrangler in wranglers.keys) {
            for (String name in wranglers[wrangler]) {
                if (processed.contains("who is $name")) {
                    return "wrangler_$wrangler";
                }
            }
        }

        return "chat";
    }

    return null;
}

//###############################

void newline() {
    chat.append(new BRElement());
    chat.scrollTop = chat.scrollHeight;
}

void pl_text(String text) {
    chat.append(new SpanElement()
        ..className = "pl"
        ..text = "PL: $text");
    newline();
}

void user_text(String text) {
    chat.append(new SpanElement()..text = "???: $text");
    newline();
}

void send_chat([Event e]) {
    String text = textbox.value;
    textbox.focus();
    if (text.isEmpty) {
        return;
    }
    textbox.value = "";
    user_text(text);
    toRead.add(text);
    writeloop();
}
