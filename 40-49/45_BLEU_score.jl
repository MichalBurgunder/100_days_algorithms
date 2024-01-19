

using StatsBase

function n_gram_generator(sentence, n = 2, n_gram = false)
    sentence = lowercase(sentence) # converting to lower case
    sent_arr = split(sentence) # split to string arrays
    length = size(sent_arr)

    word_list = []
    for i in 1:length[1]
        if i < n
            continue
        end
        word_range = (i-n+1):i
        s_list = sent_arr[word_range]
        string = join(s_list, ' ') # converting list to strings
        push!(word_list, string) # append to word_list
        if n_gram
            word_list = Set(word_list)
        end
    end

    return word_list
end

# o_sentence: original sentence
# t_sentence: translated sentence
function bleu_score(o_sentence, t_sentence)
    o_length = length(o_sentence)
    t_length = length(t_sentence)

    # we first set the penalty value for our sentence. If the translated
    # sentence is longer than the original, then clearly our translation
    # needs to be more concise to be good
    penalty = o_length < t_length ? 1 : xp(1 - (t_length/o_length))

    clipped_precision_score = []

    for i in 1:5
        og_ngram = countmap(n_gram_generator(o_sentence, i, false))
        tr_ngram = countmap(n_gram_generator(t_sentence, i, false))

        c = sum(values(tr_ngram))

        tr_ngram_intersection = Set(intersect(og_ngram, tr_ngram))

        for gram in tr_ngram_intersection
            if tr_ngram[gram[1]] > og_ngram[gram[1]]
                tr_ngram[gram[1]] = og_ngram[gram[1]]
            else
                tr_ngram[gram[1]] = 0
            end
        end

        push!(clipped_precision_score, sum(values(tr_ngram))/c)
    end

    weights = fill(0.25, 4)

    s = (w_i * log(p_i) for (w_i, p_i) in zip(weights, clipped_precision_score))
    s = penalty * exp(sum(s))
    return s
end

# we pull two sentences from the original BLEU paper to illustrate the
# translation metric, as given to us by the research paper.
original = "It is a guide to action which ensures that the 
                                military always obeys the command of the party"
machine_translated = "It is a guide to action that ensures that the military 
                                will forever heed Party commands."

println(bleu_score(original, machine_translated))