# Art of README

## Professional module spelunking

### The README: Your one-stop shop

A README is a module consumer's first -- and maybe only -- look into your creation. The consumer wants a module to fulfill their need, so you must explain exactly what need your module fills, and how effectively it does so.

Your job is to

1. tell them what it is (with context)
2. show them what it looks like in action
3. show them how they use it
4. tell them any other relevant details

This is _your_ job. It's up to the module creator to prove that their work is a shining gem in the sea of slipshod modules. Since so many developers' eyes will find their way to your README before anything else, quality here is your public-facing measure of your work.

### Brevity

The lack of a README is a powerful red flag, but even a lengthy README is not indicative of there being high quality. The ideal README is as short as it can be without being any shorter. Detailed documentation is good -- make separate pages for it! -- but keep your README succinct.

No README means developers will need to delve into your code in order to understand it.

The Perl monks have wisdom to share on the matter:

> Your documentation is complete when someone can use your module without ever having to look at its code. This is very important. This makes it possible for you to separate your module's documented interface from its internal implementation (guts). This is good because it means that you are free to change the module's internals as long as the interface remains the same.
>
> Remember: the documentation, not the code, defines what a module does.
>
> - Ken Williams

### Key elements

Once a README is located, the brave module spelunker must scan it to discern if it matches the developer's needs. This becomes essentially a series of pattern matching problems for their brain to solve, where each step takes them deeper into the module and its details.

Let's say, for example, my search for a 2D collision detection module leads me to `collide-2d-aabb-aabb`. I begin to examine it from top to bottom:

1. _Name_ -- self-explanatory names are best. `collide-2d-aabb-aabb` sounds promising, though it assumes I know what an "aabb" is. If the name sounds too vague or unrelated, it may be a signal to move on.

2. _One-liner_ -- having a one-liner that describes the module is useful for getting an idea of what the module does in slightly greater detail. `collide-2d-aabb-aabb` says it

   > Determines whether a moving axis-aligned bounding box (AABB) collides with other AABBs.

   Awesome: it defines what an AABB is, and what the module does. Now to gauge how well it'd fit into my code:

3. _Usage_ -- rather than starting to delve into the API docs, it'd be great to see what the module looks like in action. I can quickly determine whether the example JS fits the desired style and problem. People have lots of opinions on things like promises/callbacks and ES6. If it does fit the bill, then I can proceed to greater detail.

4. _API_ -- the name, description, and usage of this module all sound appealing to me. I'm very likely to use this module at this point. I just need to scan the API to make sure it does exactly what I need and that it will integrate easily into my codebase. The API section ought to detail the module's objects and functions, their signatures, return types, callbacks, and events in detail. Types should be included where they aren't obvious. Caveats should be made clear.

5. _Installation_ -- if I've read this far down, then I'm sold on trying out the module. If there are nonstandard installation notes, here's where they'd go, but even if it's just a regular `npm install`, I'd like to see that mentioned, too. New users start using Node all the time, so having a link to npmjs.org and an install command provides them the resources to figure out how Node modules work.

6. _License_ -- most modules put this at the very bottom, but this might actually be better to have higher up; you're likely to exclude a module VERY quickly if it has a license incompatible with your work. I generally stick to the MIT/BSD/X11/ISC flavours. If you have a non-permissive license, stick it at the very top of the module to prevent any confusion.

## Cognitive funneling

The ordering of the above was not chosen at random.

Module consumers use many modules, and need to look at many modules.

Once you've looked at hundreds of modules, you begin to notice that the mind benefits from predictable patterns.

You also start to build out your own personal heuristic for what information you want, and what red flags disqualify modules quickly.

Thus, it follows that in a README it is desirable to have:

1. a predictable format
2. certain key elements present

You don't need to use _this_ format, but try to be consistent to save your users precious cognitive cycles.

The ordering presented here is lovingly referred to as "cognitive funneling," and can be imagined as a funnel held upright, where the widest end contains the broadest more pertinent details, and moving deeper down into the funnel presents more specific details that are pertinent for only a reader who is interested enough in your work to have reached that deeply in the document. Finally, the bottom can be reserved for details only for those intrigued by the deeper context of the work (credits, biblio, etc.).

Once again, the Perl monks have wisdom to share on the subject:

> The level of detail in Perl module documentation generally goes from less detailed to more detailed. Your SYNOPSIS section should contain a minimal example of use (perhaps as little as one line of code; skip the unusual use cases or anything not needed by most users); the DESCRIPTION should describe your module in broad terms, generally in just a few paragraphs; more detail of the module's routines or methods, lengthy code examples, or other in-depth material should be given in subsequent sections.
>
> Ideally, someone who's slightly familiar with your module should be able to refresh their memory without hitting "page down". As your reader continues through the document, they should receive a progressively greater amount of knowledge.
>
> - from `perlmodstyle`

## Care about people's time

Awesome; the ordering of these key elements should be decided by how quickly they let someone 'short circuit' and bail on your module.

This sounds bleak, doesn't it? But think about it: your job, when you're doing it with optimal altruism in mind, isn't to "sell" people on your work. It's to let them evaluate what your creation does as objectively as possible, and decide whether it meets their needs or not -- not to, say, maximize your downloads or userbase.

This mindset doesn't appeal to everyone; it requires checking your ego at the door and letting the work speak for itself as much as possible. Your only job is to describe its promise as succinctly as you can, so module spelunkers can either use your work when it's a fit, or move on to something else that does.

## Call to arms

Go forth, brave module spelunker, and make your work discoverable and usable through excellent documentation!

## Bonus: other good practices

Outside of the key points of the article, there are other practices you can follow (or not follow) to raise your README's quality bar even further and maximize its usefulness to others:

1. Include information on types of arguments and return parameters if it's not obvious. Prefer convention wherever possible (`cb` probably means callback function, `num` probably means a `Number`, etc.).

2. Include the example code in **Usage** as a file in your repo -- maybe as `example.js`. It's great to have README code that users can actually run if they clone the repository.

3. Be judicious in your use of badges. They're easy to abuse. They can also be a breeding ground for bikeshedding and endless debate. They add visual noise to your README and generally only function if the user is reading your Markdown in a browser online, since the images are often hosted elsewhere on the internet. For each badge, consider: "what real value is this badge providing to the typical viewer of this README?" Do you have a CI badge to show build/test status? This signal would better reach important parties by emailing maintainers or automatically creating an issue. Always consider the audience of the data in your README and ask yourself if there's a flow for that data that can better reach its intended audience.

4. API formatting is highly bikesheddable. Use whatever format you think is clearest, but make sure your format expresses important subtleties:
   1. which parameters are optional, and their defaults
   2. type information, where it is not obvious from convention
   3. for `opts` object parameters, all keys and values that are accepted
   4. don't shy away from providing a tiny example of an API function's use if it is not obvious or fully covered in the **Usage** section. However, this can also be a strong signal that the function is too complex and needs to be refactored, broken into smaller functions, or removed altogether
   5. aggressively linkify specialized terminology! In markdown you can keep footnotes at the bottom of your document, so referring to them several times throughout becomes cheap.

5. If your module is a small collection of stateless functions, having a **Usage** section as a Node REPL session of function calls and results might communicate usage more clearly than a source code file to run.

6. If your module provides a CLI (command line interface) instead of (or in addition to) a programmatic API, show usage examples as command invocations and their output. If you create or modify a file, `cat` it to demonstrate the change before and after.

7. Don't forget to use `package.json` keywords to direct module spelunkers to your doorstep.

8. The more you change your API, the more work you need to exert updating documentation -- the implication here is that you should keep your APIs small and concretely defined early on. Requirements change over time, but instead of front-loading assumptions into the APIs of your modules, load them up one level of abstraction: the module set itself. If the requirements _do_ change and 'do-one-concrete-thing' no longer makes sense, then simply write a new module that does the thing you need. The 'do-one-concrete-thing' module remains a valid and valuable model for the npm ecosystem, and your course correction cost you nothing but a simple substitution of one module for another.

9. Finally, please remember that your version control repository and its embedded README will outlive your repository host and any of the things you hyperlink to -- especially images -- so _inline_ anything that is essential to future users grokking your work.

## Bonus: The README Checklist

- [ ] One-liner explaining the purpose of the module
- [ ] Potentially unfamiliar terms link to informative sources
- [ ] Clear, _runnable_ example of usage
- [ ] Installation instructions
- [ ] Extensive API documentation
- [ ] Performs [cognitive funneling](#cognitive-funneling)
- [ ] Caveats and limitations mentioned up-front
- [ ] Doesn't rely on images to relay critical information
- [ ] License
